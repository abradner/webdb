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
    #@raw_files = @import_mapping.file_type.raw_files
    @raw_files = ImportMapping::RAW_FILES
    @data_object_attributes = @data_object.data_object_attributes
    @unassigned_attrs = @data_object_attributes
    @id_attrs = @data_object.data_object_attributes.where(:is_id => true)
    @non_id_attrs = @data_object_attributes - @id_attrs
    
    # if previewing
    if params[:import_mapping]
      params[:includes_header].eql?("1") ? @includes_header = true : @includes_header = false
      @raw_file = params[:import_mapping][:raw_file]
      @delimiter = params[:import_mapping][:delimiter]

    # returning to a predefined import mapping
    elsif @import_mapping.raw_file.present? and params[:import_mapping].blank?

      @includes_header = @import_mapping.includes_header
      @raw_file = @import_mapping.raw_file
      @delimiter = @import_mapping.delimiter
      @mappings = @import_mapping.mappings
      assigned_ids = @mappings.values.map(&:to_i) if @mappings.present?
      assigned_ids ||= []
      @assigned_attrs = @data_object_attributes.where(:id => assigned_ids)
      @unassigned_attrs = @data_object_attributes - @assigned_attrs

    end

    if @raw_file
      @csv = {:header => [], :data => []}

      # read first 10 lines
      @includes_header ? limit = 11 : limit = 10
      index = 0
      #raw_file = @import_mapping.file_type.raw_files.find(@raw_file)
      file_name = "vendor/sample_data/#{@raw_file}.csv"
      FasterCSV.foreach(file_name, {:col_sep => @delimiter, :headers => @includes_header, :return_headers => true}) do |csv|

        if index > limit
          break
        end

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

  end


end
