class DataObjectFileMappingsController < AjaxDataObjectController

  load_resource :import_mapping

  def index
    @import_mapping = ImportMapping.new
  end

  def create
    @errors = true unless @import_mapping.save
  end

  def update
    @errors = true unless @import_mapping.update_attributes(params[:import_mapping])
  end

end
