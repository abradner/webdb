class Management::StorageLocationsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships

  load_and_authorize_resource :storage_location

  layout 'management'

  def new
  end

  def edit

  end

  def create
    if @storage_location.save
      redirect_to management_storage_locations_path, :notice => "The storage location was successfully created."
    else
      render :new
    end
  end

  def update
    if @storage_location.update_attributes(params[:storage])
      redirect_to management_storage_locations_path, :notice => "The storage location  was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    if @storage_location.destroy
      redirect_to management_storage_locations_url, :notice => "The storage location #{@storage_location.name} has been successfully removed."
    else
      redirect_to :back, :alert => "The storage location #{@storage_location.name} could not be deleted."
    end
  end

  def index
    #   @raw_storages = Storage.all
  end

  def show
    #TODO get rid of this
  end
end
