class DataObjectsController < ApplicationController
  respond_to :js, :except => [:show, :index]

  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :only => [:index, :show]

  load_and_authorize_resource :system
  load_and_authorize_resource :data_object, :through => :system

  def index; end
  def show; end
  def new; end
  def edit; end

    #case params[:step]
    #  when 1
    #  when 2
    #  else
    #end


  def edit_file_types_old
    @unselected_file_types = @system.file_types - @data_object.file_types
  end

  def create
    @errors = true unless @data_object.save
    prepare_attributes_for_wizard! unless @errors
  end

  def update
    @errors = true unless @data_object.update_attributes(params[:data_object])
    prepare_attributes_for_wizard! unless @errors
  end

  def activate
    if false #TODO write tests here
      @data_object.update_attribute(is_active, true)
    end
  end

  def destroy
    if @data_object.destroy
      redirect_to system_url(@data_object.system), :notice => "The data object #{@data_object.name} has been successfully removed."
    else
      redirect_to :back, :alert => "The data object #{@data_object.name} could not be deleted."
    end

  end

  def manage

  end

  private
  def prepare_attributes_for_wizard!
    @data_object_attributes = @data_object.data_object_attributes
    @data_object_attribute = DataObjectAttribute.new
  end

end
