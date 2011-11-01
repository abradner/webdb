class DataObjectAttributesController < AjaxDataObjectController

  load_resource :data_object_attribute

  def new
    @data_object_attributes = @data_object.data_object_attributes
  end

  def index
    @data_object_attributes = @data_object.data_object_attributes
    @data_object_attribute = DataObjectAttribute.new
  end

  def edit
    @data_object_attributes = @data_object.data_object_attributes
  end

  def create
    @data_object_attribute.data_object_id = params[:data_object_id]
    @errors = true unless @data_object_attribute.save
    @data_object_attributes = @data_object.data_object_attributes
  end

  def update
    #Data Object ID shouldn't change.
    #params[:data_object_attribute][:data_object_id] = params[:data_object_id]
    @errors = true unless @data_object_attribute.update_attributes(params[:data_object_attribute])
    @data_object_attributes = @data_object.data_object_attributes
  end

end
