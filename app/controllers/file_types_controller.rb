class FileTypesController < AjaxGenericController

  load_and_authorize_resource :file_type, :except => [:new, :create]

  def new
    @storage_locations = @system.storage_locations
    @file_type = FileType.new(:system => @system)
    authorize! :manage, @file_type
  end

  #def show; end
  def edit
    @storage_locations = @system.storage_locations
  end

  def index
    @file_types = @system.file_types
  end


  def create
    @file_type = FileType.new(params[:file_type])
    @file_type.extensions = FileType.parse_extension_list(params[:extension_list])
    @file_type.system = @system
    authorize! :manage, @file_type
    prepare_next_step(@file_type.save)
  end


  def update
    params[:file_type][:extensions] = FileType.parse_extension_list(params[:extension_list])
    prepare_next_step(@file_type.update_attributes(params[:file_type]))
  end

  def destroy
    if @file_type.destroy
      redirect_to system_file_types_path(@system), :notice => "The file type #{@file_type.name} has been successfully removed."
    else
      redirect_to :back, :alert => "The file type #{@file_type.name} could not be deleted."
    end

  end


  private
  def prepare_metadata_for_wizard!
    @file_metadata_schemas = @file_type.file_metadata_schemas
    @file_metadata_schema = FileMetadataSchema.new
  end

  def prepare_next_step(operation)
    if operation
      if params[:metadata]
        prepare_metadata_for_wizard!
      else
        @redirect_path = system_file_types_path(@system)
      end
    else
      @errors = true
      @storage_locations = @system.storage_locations
    end
  end
end
