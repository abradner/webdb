class DataObjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :only => [:index, :new, :create, :show, :edit, :update] #TODO remove the viewless actions

  load_and_authorize_resource :system
  load_and_authorize_resource :data_object, :through => :system

  def new
    prepare_unselected_sec_group
  end

  def create
    params[:data_object][:security_group_ids] = params[:list_selected].split ","
    if @data_object.save
      redirect_to system_path(@system), :notice => "The Data Object has been created."
    else
      render :new
    end
  end

  def edit
    prepare_unselected_sec_group
  end

  def update
    params[:data_object][:security_group_ids] = params[:list_selected].split ","
    if @data_object.update_attributes(params[:data_object])
      redirect_to system_data_object_path(@system), :notice => "The System was successfully updated."
    else
      render :edit
    end
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


  def edit_file_types
    @unselected_file_types = @system.file_types - @data_object.file_types
  end

  def update_file_types
    #params[:data_object][:file_type_ids] = params[:list_selected].split ","
    if @data_object.update_attribute(:file_type_ids, params[:list_selected].split(","))
      redirect_to system_data_object_path(@system), :notice => "The File types were successfully updated."
    else
      render :edit
    end
  end

  private


  def prepare_unselected_sec_group
    @unselected_sec_groups = @system.security_groups - @data_object.security_groups
    unless Rails.env.production?
      output = "Unselected Groups:\n"
      @unselected_sec_groups.each do |u|
        output << u.id << ": " << u.name << "\n"
      end

      output << "Selected Groups:\n"
      @data_object.security_groups.each do |s|
        output << s.id << ": " << s.name << "\n"
      end

      output << "All Groups:\n"
      @system.security_groups.each do |a|
        output << a.id << ": " << a.name << "\n"
      end

      Rails.logger.debug output
    end
  end
end
