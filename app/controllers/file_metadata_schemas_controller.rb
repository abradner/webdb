class FileMetadataSchemasController < AjaxGenericController

  load_and_authorize_resource :file_type

  #load_resource :file_metadata_schema

  def change_type
    begin
      @file_metadata_schema = @file_type.file_metadata_schemas.find(params[:id])
    rescue Mongoid::Errors::DocumentNotFound
      @file_metadata_schema = FileMetadataSchema.new
    end
    field_type = params[:selected]
    prepare_display(field_type)

  end

  def index
    @file_metadata_schema = FileMetadataSchema.new
    prepare_display(nil)
  end

  def edit
    @file_metadata_schema = @file_type.file_metadata_schemas.find(params[:id])
    prepare_display(@file_metadata_schema.field_type)
  end

  def create
    parse_options_and_selects!
    @errors = true unless @file_type.file_metadata_schemas.create(params[:file_metadata_schema])
    unless @errors
      @file_metadata_schema = FileMetadataSchema.new
      prepare_display(nil)
    end
  end

  def update
    parse_options_and_selects!
    @errors = true unless @file_type.file_metadata_schemas.create(params[:file_metadata_schema])

    if @errors
      Rails.logger.debug("Something went wrong in the update")
    else
      @errors = true unless @file_type.file_metadata_schemas.find(params[:id]).destroy
    end

    unless @errors
      @file_type = FileType.find(params[:file_type_id])
      @file_metadata_schema = FileMetadataSchema.new
      prepare_display(nil)
    end

  end

  def destroy
    @errors = true unless @file_type.file_metadata_schemas.find(params[:id]).destroy
    @file_metadata_schema = FileMetadataSchema.new
    prepare_display(nil)
  end

  #HERE BE DRAGONS
  private

  #DEAR READER:
  # I'm so, so sorry.
  # Love, Alex

  def parse_options_and_selects!

    #field :field_value,       :type => Object, :default => nil
    #field :select_options,    :type => Array, :default => nil

    if params[:option].present?
      params[:file_metadata_schema][:field_value] = params[:option]
    end

    if params[:value].present?
      values = Array.new
      params[:value].each_with_index do |v,i|
        values << Hash[:value => v[1], :selected => is_selected?(i)]
      end
      params[:file_metadata_schema][:select_options] = values
    end
    
  end

  def is_selected?(index)
    if params[:multi].to_bool
      return Integer(params[:selection][index]).to_s.to_bool
    else
      return index.eql? Integer(params[:selection])
    end
  end

  def prepare_display(field_type)
    #Fields & Radio options are currently unused.
    #They are intended so you can specify multiple fields for parameters or different options
    @display_options = Hash[
        :stored_value => nil,
        :text => nil,
        :recognised => false,
        :show_input_field => false,
        :show_interpretation_field => false,
        :show_builder => false,
        :builder_multi => false,
        :fields => nil,
        :radio_options => nil,
        :helper => nil
    ]

    if field_type.blank?
      @display_options[:text] = t('parser_strings.metadata.none')
      return
    end

    if AppConfig.metadata_types.keys.include? field_type
      @display_options[:text] = t('parser_strings.metadata.' << field_type)
      @display_options[:recognised] = true
    end

    case field_type
      when "DateTime", "Date", "Time"
        #Not relevent for metadata
        #@display_options[:show_input_field] = true
        #@display_options[:show_interpretation_field] = true
        #@display_options[:helper] = "time"
      when "Char"
        # TODO - allow regex input so we can specify exactly what characters are accepted
        #@display_options[:show_input_field] = true
        #@display_options[:show_interpretation_field] = true
        #@display_options[:helper] = "regex"
      when "Multi"

        @display_options[:stored_value] = @file_metadata_schema.collect_select_values
        @display_options[:show_builder] = true
        @display_options[:builder_multi] = true
      when "Radio", "Select"
        @display_options[:stored_value] = @file_metadata_schema.collect_select_values
        @display_options[:show_builder] = true
      when "Integer"
        #@display_options[:fields] = %w(Minimum Maximum)
        #@display_options[:helper] = "integer"
      when "Float"
        @display_options[:stored_value] = @file_metadata_schema.field_value
        @display_options[:show_input_field] = true
      #@display_options[:radio_options] = %w(Decimal Places, Sig Fig)
      #@display_options[:helper] = "float"
      else
        #when "String"
        #when "Text"
        #when "Blob"
        @display_options[:stored_value] = @file_metadata_schema.field_value
        @display_options[:show_input_field] = true
    end
  end

end
