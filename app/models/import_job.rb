class ImportJob
  include Mongoid::Document
  belongs_to :system
  belongs_to :data_object
  belongs_to :import_mapping
  belongs_to :raw_file
  belongs_to :created_by_user, :class_name => 'User'

  def import

    import_mapping.mappings


    case import_mapping.delimiter
      when "\\t"
        converted_delimiter = "\t"
      when "\\s"
        converted_delimiter = "\s"
      else
        converted_delimiter = import_mapping.delimiter
    end

    FasterCSV.foreach(file_name, {:col_sep => converted_delimiter, :headers => import_mapping.includes_header, :return_headers => false}) do |csv|

      # FasterCSV returns arrays if headers => false, and FasterCSV:Rows if true
      if @includes_header
        if csv.header_row?
          @csv[:header] = csv.fields
        else
          @csv[:data] << csv.fields
        end
      else

        if index == 0
          @csv[:header] = (1..csv.size).to_a
        end
        @csv[:data] << csv

      end

      index += 1

    end

  end

  handle_asynchronously :import


end
