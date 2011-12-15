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
    flash.now[:notice] = "Import mapping updated successfully." unless @errors
    @import_mapping = ImportMapping.new unless @errors
    @import_mappings = @data_object.import_mappings
    @file_types = @system.file_types
  end

  def preview
    @raw_files = @import_mapping.file_type.raw_files
    @data_object_attributes = @data_object.data_object_attributes

    @assigned_attrs = {}
    @unassigned_attrs = @data_object_attributes
    @id_attrs = @data_object.data_object_attributes.where(:is_id => true)
    @non_id_attrs = @data_object_attributes - @id_attrs

    # if previewing
    if params[:import_mapping]
      params[:includes_header].eql?("1") ? @includes_header = true : @includes_header = false
      @raw_file = RawFile.find(params[:import_mapping][:raw_file_id])
      @delimiter = params[:import_mapping][:delimiter]

      # returning to a predefined import mapping
    elsif @import_mapping.raw_file.present? and params[:import_mapping].blank?

      @includes_header = @import_mapping.includes_header
      @raw_file = @import_mapping.raw_file
      @delimiter = @import_mapping.delimiter
      mappings = @import_mapping.mappings.invert
      assigned_ids = mappings.keys if mappings.present?
      assigned_ids ||= []
      values = @data_object_attributes.any_in(:_id => assigned_ids)

      values.each do |value|
        @assigned_attrs[mappings["#{value.id}"]] = value
      end

      @unassigned_attrs = @data_object_attributes - values

    end

    if @raw_file
      @csv = {:header => [], :data => []}

      # read first 10 lines
      @includes_header ? limit = 11 : limit = 10
      index = 0

      case @delimiter
        when "\\t"
          converted_delimiter = "\t"
        when "\\s"
          converted_delimiter = "\s"
        else
          converted_delimiter = @delimiter
      end

      #TODO handle exception of non csv readable files
      
      FasterCSV.new(@raw_file.open_file, {:col_sep => converted_delimiter, :headers => @includes_header, :return_headers => true}).each do |row|

        # TODO use lineno
        if index > limit
          break
        end


        # FasterCSV returns arrays if headers => false, and FasterCSV:Rows if true
        if @includes_header
          if row.header_row?
            @csv[:header] = row.fields
            @num_of_columns = row.fields.count

            if params[:import_mapping]

              @data_object_attributes.each do |doa|
                if row.fields.include?(doa.name) or row.fields.include?(doa.label)
                  @assigned_attrs["column_#{row.fields.index(doa.name)}"] = doa
                end
              end
              @unassigned_attrs = @data_object_attributes - @assigned_attrs.values

            end

          else
            @csv[:data] << row.fields
          end
        else

          if index == 0
            @csv[:header] = (1..row.size).to_a
            @num_of_columns = row.count

          end
          @csv[:data] << row

        end


        index += 1

      end
    end

  end


end
