class DataObjectFileMappingsController < AjaxDataObjectController

  load_resource :data_object_file_mapping

  def index
    @data_object_file_mapping = DataObjectFileMapping.new
  end

  def create
    @errors = true unless @data_object_file_mapping.save
  end

  def update
    @errors = true unless @data_object_file_mapping.update_attributes(params[:data_object_file_mapping])
  end

end
