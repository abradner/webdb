class ImportJob
  include Mongoid::Document
  include Tenacity
  belongs_to :data_object
  belongs_to :import_mapping
  #TODO belongs_to :raw_file
  t_belongs_to :user

  field :raw_file, :type => String
  field :valid, :type => Boolean

  def import


  end

  handle_asynchronously :import

  def validate_file
    notify_user_of_import_validation_started(self)
    @mappings = {}
    
    results = []

    import_mapping.each do |k,v|
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

    #TODO raw_file = @import_mapping.file_type.raw_files.find(@raw_file)
    file_name = "vendor/sample_data/#{@raw_file}.csv"
    FasterCSV.open(file_name, "rb", {:col_sep => converted_delimiter, :headers => import_mapping.includes_header, :return_headers => true}) do |csv|

      csv.each do |row|

        fields = row.fields
        line_num = csv.lineno
        unique_fields = import_mapping.unique_fields
        # do these quick validations only once
        if line_num == 1

          #if the number of fields is not the same as recorded during import mapping definition, file is immediately invalid
          if fields.count != import_mapping.num_of_columns
            results << "The file is invalid for importing as it does not have #{import_mapping.num_of_columns} columns."
            break
          end

          #validate header is the same if it exists, file is immediately invalid
          if row.header_row? and import_mapping.includes_header
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

        #do row-by-row validations
        @mappings.each do |col_no, doa|

          value = fields[col_no]

          query[doa.name]
        end

        if @data_object.data_object_rows.where(query).entries.present?

          case import_mapping.conflict_action
            when ImportMapping::APPEND

            when ImportMapping::OVERWRITE

            when ImportMapping::DELETE

          end

        end

      end
    end

    notify_user_of_import_validation_ended(self, results)

  end

  handle_asynchronously :validate_file

end
