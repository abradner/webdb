class ImportJob
  include Mongoid::Document
  include Tenacity
  belongs_to :data_object
  belongs_to :import_mapping
  belongs_to :raw_file
  t_belongs_to :user

  field :valid, :type => Boolean

  def import


  end

  handle_asynchronously :import

  def validate_file
    Notifier.notify_user_of_import_validation_started(self).deliver
    @mappings = {}

    results = []

    import_mapping.mappings.each do |k, v|
      @mappings[k[/\d+/].to_i] = DataObjectAttribute.find(v)
    end

    @data_object = import_mapping.data_object

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
      unique_fields = import_mapping.unique_fields

      # do these quick validations only once
      if line_num == 1

        #if the number of fields is not the same as recorded during import mapping definition, file is immediately invalid
        if fields.count != import_mapping.num_of_columns
          results << "The file is invalid for importing as it does not have #{import_mapping.num_of_columns} columns."
          break
        end

        #validate header is the same if it exists, file is immediately invalid
        if import_mapping.includes_header
          if fields != import_mapping.header_row
            results << "The file is invalid for importing as it does not have the same headers as defined in the import mapping."
            break

          end
        end

        #if there are no unique fields, data is always appended, therefore valid
        if unique_fields.empty?
          results << "This file is valid and all data will be appended to the Data Object."
          break

        end
      end

      query = {}
      is_valid = true

      #build a query to check if a data object row exists
      @mappings.each do |col_no, doa|

        key = doa.name
        value = fields[col_no]

        # mark invalid if the current attribute is an identifier and its value is nil or doesn't exist
        if value.blank?
          is_valid = false if unique_fields.include?(key)
          results << "Row #{line_num} does not have a value for #{key}"
          break

        else
          query[key] = value
        end

      end


      # by now, all unique fields have been checked
      # skip if row is invalid already.
      if is_valid

        entries = @data_object.data_object_rows.where(query).entries

        if entries.present?
          # if one is valid, so are the others
          row = entries.first.assign_attributes(query, :without_protection => true)

        else
          row = @data_object.data_object_rows.build(query)
        end

        results << "Row #{line_num} is invalid and will not be imported into the data object" unless row.valid?

      end

    end

    if results.blank?
      results << "No errors detected with this file."
    end

    Notifier.notify_user_of_import_validation_ended(self, results).deliver

  end

  handle_asynchronously :validate_file

end
