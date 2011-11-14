class FileTypesController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :system
  #load_and_authorize_resource :file_type, :through => :system_id
  #load_and_authorize_resource :storage_location, :through => :system, :only => [:new, :edit]

  before_filter :systems_and_memberships, :only => [:index, :new, :create, :show, :edit, :update] #TODO remove the viewless actions

  def new
    @file_type = FileType.new
    @storage_locations = @system.storage_locations
  end

  def show; end
  def edit
    @file_type = FileType.find(params[:id])
    @storage_locations = @system.storage_locations
  end

  def index
    @file_types = @system.file_types
  end


  def create
    @file_type = FileType.new(params[:file_type])
    @file_type.system = @system
    if @file_type.save
      redirect_to system_file_types_path(@system), :notice => "The file type has been created."
    else
      render :new
    end
  end


  def update
    @file_type = FileType.find(params[:id])
    #sanitise_params_for_sec_group!
    if @file_type.update_attributes(params[:file_type])
      redirect_to system_file_types_path(@system), :notice => "The file type has been updated."
    else
      render :edit
    end
  end

  def destroy
    if @file_type.destroy
      redirect_to system_file_types_path(@system), :notice => "The file type #{@file_type.name} has been successfully removed."
    else
      redirect_to :back, :alert => "The file type #{@file_type.name} could not be deleted."
    end

  end


end
