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
    @mappings = import_mapping.mappings
    results = []


    case import_mapping.delimiter
      when "\\t"
        converted_delimiter = "\t"
      when "\\s"
        converted_delimiter = "\s"
      else
        converted_delimiter = import_mapping.delimiter
    end

    

    FasterCSV.foreach(file_name, {:col_sep => converted_delimiter, :headers => import_mapping.includes_header, :return_headers => false}) do |csv|

      #if the number of fields is not the same as recorded during import mapping definition, file is invalid
      if csv.fields.count != import_mapping.num_of_columns
        results << "The file is invalid for importing as it does not have #{import_mapping.num_of_columns} columns."
        break
      end

      
      

    end
    
    notify_user_of_import_validation_ended(self, results)

  end

  handle_asynchronously :validate_file

end
