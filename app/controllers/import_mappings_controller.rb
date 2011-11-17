class ImportMappingsController < AjaxDataObjectController


  load_and_authorize_resource :system
  load_and_authorize_resource :data_object
  load_resource :import_mapping

  def index
    @import_mappings = @data_object.import_mappings
    @file_types = @system.file_types
    @import_mapping = ImportMapping.new

  end

  def create
    @import_mapping.data_object_id = params[:data_object_id]

    if @import_mapping.save
      @import_mapping = ImportMapping.new
      flash.now[:notice] = "Import mapping created successfully."

    else
      @errors = true

    end


    @import_mappings = @data_object.import_mappings
    @file_types = @system.file_types
  end

  def update
    @errors = true unless @import_mapping.update_attributes(params[:import_mapping])
    @import_mapping = ImportMapping.new unless @errors

    @import_mappings = @data_object.import_mappings
    @file_types = @system.file_types
  end

  def preview
    require 'faster_csv'
    #@raw_files = @import_mapping.file_type.raw_files
    @raw_files = ["contract", "customer_order_total", "GeoIPCountryWhois", "students", "transaction"]
    @delimiters = [["Comma", ","],["Tab", "\t"], ["Semicolon", ";"],  ["Space", "\s"], ["Pipe", "|"]]

    params[:header].present? ? @header = true : @header = false
    @raw_file = params[:raw_file]
    @delimiter = params[:delimiter]
    @csv = {:header => [], :data => []}

    if @raw_file

      # read first 10 lines
      @header ? limit = 11 : limit = 10
      index = 0

      FasterCSV.foreach("vendor/sample_data/#{@raw_file}.csv", {:col_sep => @delimiter, :headers => @header, :return_headers => true}) do |csv|

        if index > limit
          break
        end

        # FasterCSV returns arrays if headers => false, and FasterCSV:Rows if true
        if @header
          if csv.header_row?
            puts "blah"
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

    puts @csv[:header]
    puts
    puts
    puts
    puts
    puts @csv[:data]

  end


end
