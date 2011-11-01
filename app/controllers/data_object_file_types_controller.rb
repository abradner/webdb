class DataObjectFileTypesController < AjaxDataObjectController

  load_resource :data_object_file_type

  def create
    @errors = true unless @data_object.save
  end

  def update
    @errors = true unless @data_object.update_attribute(:file_type_ids, params[:list_selected].split(","))
  end

end
