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

  def import
    @import_mappings = @data_object.import_mappings.select { |im| im.mappings.present? }
  end

  # updates list of available file types to import based on mapping
  def mapping_selected

    @import_mapping = ImportMapping.find(params[:data_object][:import_mappings])
    #@raw_files = @import_mapping.file_type.raw_files
    @raw_files = ImportMapping::RAW_FILES
  end

  # does the actual import
  def import_selected
    @import_mapping = ImportMapping.find(params[:import_mapping])
    @raw_file = RawFile.find(params[:raw_file])
    @data_object.import(@import_mapping, @raw_file)
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
