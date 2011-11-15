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

    @errors = true unless @import_mapping.save

    @import_mapping = ImportMapping.new unless @errors

    @import_mappings = @data_object.import_mappings
    @file_types = @system.file_types
  end

  def update
    @errors = true unless @import_mapping.update_attributes(params[:import_mapping])
    @import_mapping = ImportMapping.new unless @errors

    @import_mappings = @data_object.import_mappings
    @file_types = @system.file_types
  end

end
