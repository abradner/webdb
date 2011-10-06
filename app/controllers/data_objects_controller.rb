class DataObjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :only => [:index, :new, :create, :show, :edit, :update] #TODO remove the viewless actions

  load_and_authorize_resource :system
  load_and_authorize_resource :data_object, :through => :system

  def new
  end

  def create
    if @data_object.save
      redirect_to system_path(@system), :notice => "The Data Object has been created."
    else
      render :new
    end
  end

  def edit
    if @data_object.update_attributes(params[:data_object])
      redirect_to system_data_object_path(@system), :notice => "The System was successfully updated."
    else
      render :edit
    end
  end

  def update
  end

  def destroy
    if @data_object.destroy
      redirect_to system_data_object_url, :notice => "The data object #{@data_object.name} has been successfully removed."
    else
      redirect_to :back, :alert => "The data object #{@data_object.name} could not be deleted."
    end

  end

  def show
  end

  def index
  end
end
