class ImportJob
  include Mongoid::Document
  include Tenacity
  belongs_to :data_object
  belongs_to :import_mapping
  belongs_to :raw_file
  t_belongs_to :user

  field :can_import, :type => Boolean, :default => true
  field :validated, :type => Boolean, :default => false
  field :imported, :type => Boolean, :default => false
  field :status, :type => String,  :default => "Initialized"

  validates_inclusion_of [:can_import, :validated, :imported], :in => [true, false]

  def import

    self.update_attribute(:status, "Importing Data")

    Notifier.notify_user_of_import_started(self).deliver
    @mappings = {}
    @unique_fields = []

    results = []

    if !self.can_import
      results << "Attempted import of invalid file."
      Notifier.notify_user_of_import_ended(self, results).deliver
      return
    end

    import_mapping.mappings.each do |k, v|
      doa = DataObjectAttribute.find(v)
      @mappings[k[/\d+/].to_i] = doa
      @unique_fields << doa.name if import_mapping.unique_fields.include?(v)
    end

    @data_object = import_mapping.data_object

    @action = import_mapping.conflict_action

    case import_mapping.delimiter
      when "\\t"
        converted_delimiter = "\t"
      when "\\s"
        converted_delimiter = "\s"
      else
        converted_delimiter = import_mapping.delimiter
    end

    #TODO handle exception of non csv readable files

    line_num = 0

    FasterCSV.new(self.raw_file.open_file, {:col_sep => converted_delimiter, :headers => @includes_header, :return_headers => false}).each do |row|
      #increment before any breaks
      line_num += 1

      fields = row
      query = {}
      new_attrs = {}

      is_valid = true

      #build a query to check if a data object row exists
      @mappings.each do |col_no, doa|

        key = doa.name
        value = fields[col_no]

        # mark invalid if the current attribute is an identifier and its value is nil or doesn't exist
        # use unique values to query
        if @unique_fields.include?(key)
          if value.blank?
            is_valid = false
            results << "Row #{line_num} does not have a value for #{key} and was skipped"
            break

          else
            query[key] = value
          end
        end

        new_attrs[key] = value

      end


      # by now, all unique fields have been checked
      # skip if row is invalid already.
      if is_valid

        entries = @data_object.data_object_rows.where(query).entries

        case @action
          when ImportMapping::APPEND
            if entries.blank?
              row = @data_object.data_object_rows.build(new_attrs)

              results << "Row #{line_num} was added to the data object" if row.save
            else
              results << "Row #{line_num} exists in the data object already"

            end

          when ImportMapping::DELETE
            count = entries.count
            entries.map(&:destroy) if entries.present?
            results << "Row #{line_num} deleted #{count} records"

          when ImportMapping::OVERWRITE
            count = 0

            entries.each do |entry|
              if entries.present?
                count += 1 if entry.update_attributes(new_attrs)

              end

            end
            results << "Row #{line_num} overwrote #{count} records" unless row.save
          else
            results << "Row #{line_num} skipped"

        end


      end

    end

    self.update_attribute(:imported, true)
    self.update_attribute(:status, "Data Imported")

    Notifier.notify_user_of_import_ended(self, results).deliver

  end

  handle_asynchronously :import

  def validate_file
    self.update_attribute(:status, "Validating")
    Notifier.notify_user_of_import_validation_started(self).deliver
    @mappings = {}
    @unique_fields = []
    results = []

    import_mapping.mappings.each do |k, v|
      doa = DataObjectAttribute.find(v)
      @mappings[k[/\d+/].to_i] = doa
      @unique_fields << doa.name if import_mapping.unique_fields.include?(v)
    end

    @data_object = import_mapping.data_object

    @action = import_mapping.conflict_action

    case import_mapping.delimiter
      when "\\t"
        converted_delimiter = "\t"
      when "\\s"
        converted_delimiter = "\s"
      else
        converted_delimiter = import_mapping.delimiter
    end

    #TODO handle exception of non csv readable files

    line_num = 0

    FasterCSV.new(self.raw_file.open_file, {:col_sep => converted_delimiter, :headers => @includes_header, :return_headers => true}).each do |row|
      #increment before any breaks
      line_num += 1

      fields = row

      # do these quick validations only once
      if line_num == 1

        #if the number of fields is not the same as recorded during import mapping definition, file is immediately invalid
        if fields.count != import_mapping.num_of_columns
          results << "The file is invalid for importing as it does not have #{import_mapping.num_of_columns} columns."
          self.update_attribute(:can_import, false)
          self.update_attribute(:validated, true)
          self.update_attribute(:status, "Validated - Raw file invalid")
          break
        end

        #validate header is the same if it exists, file is immediately invalid
        if import_mapping.includes_header
          if fields != import_mapping.header_row
            results << "The file is invalid for importing as it does not have the same headers as defined in the import mapping."
            self.update_attribute(:can_import, false)
            self.update_attribute(:validated, true)
            self.update_attribute(:status, "Validated - Raw file invalid")
            break

          end
        end

        #if there are no unique fields, data is always appended, therefore valid
        if @unique_fields.empty?
          results << "This file is valid and all data will be appended to the Data Object."
          break

        end
      end

      query = {}
      new_attrs = {}

      is_valid = true

      #build a query to check if a data object row exists
      @mappings.each do |col_no, doa|

        key = doa.name
        value = fields[col_no]


        # mark invalid if the current attribute is an identifier and its value is nil or doesn't exist
        # use unique values to query
        if @unique_fields.include?(key)
          if value.blank?
            is_valid = false
            results << "Row #{line_num} does not have a value for #{key}"
            break

          else
            query[key] = value
          end
        end

        new_attrs[key] = value

      end


      # by now, all unique fields have been checked
      # skip if row is invalid already.
      if is_valid

        entries = @data_object.data_object_rows.where(query).entries

        case @action
          when ImportMapping::APPEND
            if entries.blank?
              row = @data_object.data_object_rows.build(new_attrs)
              results << "Row #{line_num} is invalid and will not be imported into the data object" unless row.valid?

            else
              results << "Row #{line_num} exists in the data object already"

            end

          when ImportMapping::DELETE
            #nothing to report, always valid for deleting
          when ImportMapping::OVERWRITE
            row = entries.first.assign_attributes(new_attrs, :without_protection => true) if entries.present?
            results << "Row #{line_num} is invalid and will not be imported into the data object" unless row.valid?

        end
      end

    end

    if results.blank?
      results << "No errors detected with this file."
    end

    self.update_attribute(:validated, true)
    self.update_attribute(:status, "Validated. Ready for import")

    Notifier.notify_user_of_import_validation_ended(self, results).deliver

  end

  handle_asynchronously :validate_file

end
