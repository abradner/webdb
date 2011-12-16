class ImportJob
  include Mongoid::Document
  include Mongoid::Timestamps

  include Tenacity
  belongs_to :data_object
  belongs_to :import_mapping
  belongs_to :raw_file

  t_belongs_to :user

  field :can_import, :type => Boolean, :default => false
  field :validated, :type => Boolean, :default => false
  field :imported, :type => Boolean, :default => false
  field :status, :type => String, :default => "Pending validation"
  field :total_count, :type => Integer, :default => 0
  field :current_count, :type => Integer, :default => 0
  field :started_process_at, :type => DateTime

  validates_inclusion_of [:can_import, :validated, :imported], :in => [true, false]

  def import

    if !self.can_import
      return
    end

    self.update_attribute(:started_process_at, Time.now)
    self.update_attribute(:status, "Importing data")

    Notifier.notify_user_of_import_started(self).deliver
    @mappings = {}
    @unique_fields = []

    results = []

    import_mapping.mappings.each do |k, v|
      doa = DataObjectAttribute.find(v)
      @mappings[k[/\d+/].to_i] = doa
      @unique_fields << doa.name if import_mapping.unique_fields.include?(v)
    end

    @data_object = import_mapping.data_object
    @includes_header = import_mapping.includes_header
    @action = import_mapping.action

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

    # includes_header not relevant in reading a file
    # because headers => false returns Array while
    # headers => true returns FasterCSV::Row
    # which is pretty annoying

    #How long is the file?
    file = self.raw_file.open_file
    self.update_attribute :total_count, file.readlines.size
    file.seek(0)

    update_interval = AppConfig['update_status_interval'] || 100

    FasterCSV.new(file, {:col_sep => converted_delimiter, :return_headers => false}).each do |line|

      if line_num % update_interval == 0
        self.update_attribute(:current_count, line_num)
        self.update_attribute(:status, "Processed #{line_num}/#{self.total_count} rows")
      end

      #increment before any breaks
      line_num += 1

      if @includes_header and line_num == 1
        next
      end

      fields = line
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
            results << "Line #{line_num} does not have a value for #{key} and was skipped"
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
          when ImportMapping::CREATE

            if entries.blank?
              row = @data_object.data_object_rows.build(new_attrs)
              results << "Line #{line_num} was added to the data object" if row.save
            else
              results << "Line #{line_num} exists in the data object already"
            end

          when ImportMapping::UPDATE

            count = 0

            entries.each do |entry|
              count += 1 if entry.update_attributes(new_attrs)
            end

            results << "Line #{line_num} overwrote #{count} record(s)"

          when ImportMapping::BOTH

            if entries.blank?
              row = @data_object.data_object_rows.build(new_attrs)

              results << "Line #{line_num} was added to the data object" if row.save
            else
              count = 0

              # if entries exist, update
              entries.each do |entry|
                count += 1 if entry.update_attributes(new_attrs)
              end
              results << "Line #{line_num} overwrote #{count} record(s)"
            end

          when ImportMapping::DELETE
            count = entries.count
            entries.map(&:destroy) if entries.present?
            results << "Line #{line_num} deleted #{count} record(s)"

          else
            results << "Line #{line_num} skipped"

        end


      end

    end

    self.update_attribute(:imported, true)
    self.update_attribute(:status, "Data imported")
    self.update_attribute(:started_process_at, nil)

    Notifier.notify_user_of_import_ended(self, results).deliver

  end

  handle_asynchronously :import

  def validate_file

    self.update_attribute(:started_process_at, Time.now)
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
    @includes_header = import_mapping.includes_header
    @action = import_mapping.action

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

    # includes_header not relevant in reading a file
    # because headers => false returns Array while
    # headers => true returns FasterCSV::Row
    # which is pretty annoying

    #How long is the file?
    file = self.raw_file.open_file
    self.update_attribute :total_count, file.readlines.size
    file.seek(0)

    update_interval = AppConfig['update_status_interval'] || 100
    begin
      FasterCSV.new(file, {:col_sep => converted_delimiter, :return_headers => false}).each do |line|

        if line_num % update_interval == 0
          self.update_attribute(:current_count, line_num)
          self.update_attribute(:status, "Processed #{line_num}/#{self.total_count} rows")
        end

        #increment before any breaks
        line_num += 1

        fields = line

        # do these quick validations only once
        if line_num == 1

          #if the number of fields is not the same as recorded during import mapping definition, file is immediately invalid
          if fields.count != import_mapping.num_of_columns
            results << "The file is invalid for importing as it does not have #{import_mapping.num_of_columns} columns."
            self.update_attribute(:can_import, false)
            self.update_attribute(:validated, true)
            self.update_attribute(:started_process_at, nil)
            self.update_attribute(:status, "Validated - Raw file invalid, import disabled")
            break
          end

          #validate header is the same if it exists, file is immediately invalid
          if import_mapping.includes_header
            if fields != import_mapping.header_row
              results << "The file is invalid for importing as it does not have the same headers as defined in the import mapping."
              self.update_attribute(:can_import, false)
              self.update_attribute(:validated, true)
              self.update_attribute(:started_process_at, nil)
              self.update_attribute(:status, "Validated - Raw file invalid, import disabled")
              break
            end
          end

          #if there are no unique fields, data is always appended, therefore valid
          if @unique_fields.empty?
            self.update_attribute(:can_import, true)
            self.update_attribute(:validated, true)
            self.update_attribute(:started_process_at, nil)
            self.update_attribute(:status, "Validated. Ready for import")
            results << "This file is valid and all data will be appended to the data object"
            break
          end

          next
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
              results << "Line #{line_num} does not have a value for #{key}"
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
            when ImportMapping::CREATE
              if entries.blank?
                row = @data_object.data_object_rows.build(new_attrs)
                unless row.valid?
                  results << "Line #{line_num} is invalid and will not be imported into the data object"
                  row.errors.full_messages.each do |message|
                    results << " - " + message
                  end
                end

              else
                results << "Line #{line_num} exists in the data object already"
              end
            when ImportMapping::UPDATE
              if entries.present?
                row = entries.first.assign_attributes(new_attrs, :without_protection => true)
                unless row.valid?
                  results << "Line #{line_num} is invalid and will not be imported into the data object"
                  row.errors.full_messages.each do |message|
                    results << " - " + message
                  end
                end

              end

            when ImportMapping::BOTH
              if entries.present?

                row = entries.first.assign_attributes(new_attrs, :without_protection => true)
                unless row.valid?
                  results << "Line #{line_num} is invalid and will not be imported into the data object"
                  row.errors.full_messages.each do |message|
                    results << " - " + message
                  end
                end

              else
                row = @data_object.data_object_rows.build(new_attrs)
                unless row.valid?
                  results << "Line #{line_num} is invalid and will not be imported into the data object"
                  row.errors.full_messages.each do |message|
                    results << " - " + message
                  end
                end

              end

            when ImportMapping::DELETE
              #nothing to report, always valid for deleting
          end
        end

      end

      if results.blank?
        results << "No errors detected with this file."
      end

      self.update_attribute(:can_import, true)
      self.update_attribute(:validated, true)
      self.update_attribute(:status, "Validated and ready to import")
      self.update_attribute(:started_process_at, nil)

    rescue FasterCSV::MalformedCSVError
      results << "The file is not a valid csv"
      self.update_attribute(:can_import, false)
      self.update_attribute(:validated, true)
      self.update_attribute(:started_process_at, nil)

      self.update_attribute(:status, "Validated - Raw file invalid, import disabled")
      return
    end

    Notifier.notify_user_of_import_validation_ended(self, results).deliver

  end

  handle_asynchronously :validate_file

  def reset
    @import_job.update_attribute(:status, "Pending validation")
    @import_job.update_attribute(:validated, false)
    @import_job.update_attribute(:can_import, false)
    @import_job.update_attribute(:imported, false)
    @import_job.update_attribute(started_process_at,false)

  end


end
