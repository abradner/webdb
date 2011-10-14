class DataObjectRelationshipsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :only => [:index, :new, :create, :show, :edit, :update] #TODO remove the viewless actions

  load_and_authorize_resource :system
  
  load_and_authorize_resource :data_object
  #load_and_authorize_resource :relative, :class => "DataObject"
  load_resource :data_object_relationship

  def create
    rel_id = params[:data_object_relationship][:relative_id]
    @data_object_relationship = @data_object.data_object_relationships.build(:relative_id => rel_id)
    if @data_object_relationship.save
      redirect_to system_data_object_path(@system, @data_object), :notice => "This data object has been successfully linked to \"#{@data_object_relationship.relative.name}\"."
    else
      redirect_to system_data_object_path(@system, @data_object), :notice => "The relationship between data objects \"#{@data_object.name}\" and \"#{@data_object_relationship.relative.name}\" could not be created."
    end
  end


  def index
    @data_object_relationship = DataObjectRelationship.new
  end


  def destroy
    if @data_object_relationship.destroy
      redirect_to system_data_object_path(@system, @data_object), :notice => "The relationship between data objects \"#{@data_object.name}\" and \"#{@data_object_relationship.relative.name}\" has been successfully removed."
    else
      redirect_to :back, :alert => "The relationship between data objects \"#{@data_object.name}\" and \"#{@data_object_relationship.relative.name}\" could not be removed."
    end
  end

end
