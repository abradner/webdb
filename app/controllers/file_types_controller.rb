class FileTypesController < ApplicationController
  before_filter :authenticate_user!

  load_and_authorize_resource :system
  load_and_authorize_resource :file_type, :through => :system
  load_and_authorize_resource :storage_location, :through => :system, :only => [:new, :edit]

  before_filter :systems_and_memberships, :only => [:index, :new, :create, :show, :edit, :update] #TODO remove the viewless actions

  #load_and_authorize_resource :data_object, :through => :system

  def new; end

  def create
    if @file_type.save
      redirect_to system_file_types_path(@system), :notice => "The file type has been created."
    else
      render :new
    end
  end

  def edit; end

  def update
    #sanitise_params_for_sec_group!
    if @file_type.update_attribute(:user_ids, params[:member_ids])
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

  def show
  end

  def index
  end

end
