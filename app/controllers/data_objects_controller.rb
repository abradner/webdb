class DataObjectsController < ApplicationController
  respond_to :js, :except => [:show, :index]

  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :only => [:index, :show]

  load_and_authorize_resource :system
  load_and_authorize_resource :data_object, :except => [:new, :create]

  def index;
  end

  def show;
  end

  def new
    @data_object = DataObject.new(:system => @system)
    authorize! :new, @data_object
  end

  def edit
    unless @data_object.is_active?
      redirect_to :back, :alert => "The Data Object #{@data_object.name} is inactive and cannot be changed. Reactivate it first."
      return
    end
  end

  def configure;
  end

  def edit_file_types_old
    @unselected_file_types = @system.file_types - @data_object.file_types
  end

  def create
    @data_object = DataObject.new(params[:data_object].merge({:system => @system}))
    authorize! :new, @data_object
    @data_object.system = @system
    @errors = true unless @data_object.save
    prepare_attributes_for_wizard! unless @errors
  end

  def update
    unless @data_object.is_active?
      redirect_to :back, :alert => "The Data Object #{@data_object.name} is inactive and cannot be changed. Reactivate it first."
      return
    end
    @errors = true unless @data_object.update_attributes(params[:data_object])
    prepare_attributes_for_wizard! unless @errors
  end

  def activate
    @data_object.activate!
    redirect_to system_data_object_path(@system, @data_object), :notice => "The Data Object was successfully activated."
  end

  def deactivate
    @data_object.deactivate!
    redirect_to system_data_object_path(@system, @data_object), :notice => "The Data Object was successfully deactivated."
  end

  def import
    @import_mappings = @data_object.import_mappings.select { |im| im.mappings.present? }
  end

  # updates list of available file types to import based on mapping
  def mapping_selected

    @import_mapping = ImportMapping.find(params[:data_object][:import_mappings])
    @raw_files = @import_mapping.file_type.raw_files
  end

  # does the actual import
  def import_selected
    import_job = ImportJob.create(:user_id => current_user.id, :data_object => @data_object, :import_mapping_id => params[:import_mapping_id], :raw_file_id => params[:raw_file_id])
    import_job.validate_file
    flash[:notice] = "The import job was created successfully and is undergoing validations."
    @redirect_path = system_data_object_url(@system, @data_object)
  end


  def destroy
    if @data_object.is_active?
      redirect_to :back, :alert => "The Data Object #{@data_object.name} is active and cannot be deleted. Deactivate it first."
      return
    end

    if @data_object.destroy
      redirect_to system_url(@data_object.system), :notice => "The data object #{@data_object.name} has been successfully removed."
    else
      redirect_to :back, :alert => "The data object #{@data_object.name} could not be deleted."
    end

  end


  private
  def prepare_attributes_for_wizard!
    @data_object_attributes = @data_object.data_object_attributes
    @data_object_attribute = DataObjectAttribute.new
  end

end
