class AjaxDataObjectController < AjaxGenericController

  load_and_authorize_resource :data_object

  def update
    @errors = true unless @data_object.update_attributes(params[:data_object])
  end

end
