class FileMetadataSchemasController < AjaxGenericController

  load_and_authorize_resource :file_type
  #load_resource :file_metadata_schema

  def edit
    @file_metadata_schema = @file_type.file_metadata_schemas.find(params[:id])
  end

  def index
    @file_metadata_schema = FileMetadataSchema.new
  end


  def create
    @errors = true unless @file_type.file_metadata_schemas.create(params[:file_metadata_schema])
    @file_metadata_schema = FileMetadataSchema.new unless @errors
  end


  def update
    @errors = true unless @file_type.file_metadata_schemas.create(params[:file_metadata_schema])
    @errors = true unless @file_type.file_metadata_schemas.find(params[:id]).destroy
    @file_metadata_schema = FileMetadataSchema.new #TODO do we need unless @errors?

  end

  def destroy
    @errors = true unless @file_type.file_metadata_schemas.find(params[:id]).destroy
    @file_metadata_schema = FileMetadataSchema.new
  end

end
