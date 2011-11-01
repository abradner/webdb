class Management::StoragesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships

  load_and_authorize_resource :storage

  layout 'management'

  def new
  end
  
  def edit
    
  end
  
  def create
    if @storage.save
      redirect_to management_storages_path, :notice => "The storage location was successfully created."
    else
      render :new
    end    
  end
  
  def update
    if @storage.update_attributes(params[:storage])
      redirect_to management_storages_path, :notice => "The storage location  was successfully updated."
    else
      render :edit
    end    
  end
  
  def destroy
    if @storage.destroy
      redirect_to management_storages_url, :notice => "The storage location #{@storage.name} has been successfully removed."
    else
      redirect_to :back, :alert => "The storage location #{@storage.name} could not be deleted."
    end    
  end
  
  def index
 #   @raw_storages = Storage.all
  end
  
  def show
    #TODO get rid of this
  end
end
