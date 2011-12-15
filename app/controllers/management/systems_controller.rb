class Management::SystemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships

  load_and_authorize_resource :system

  layout 'management'

  def new
    @colour_schemes = ColourScheme.all
  end

  def edit
    unless @system.is_active?
      redirect_to management_systems_path, :alert => "The system #{@system.name} is inactive and cannot be changed. Reactivate it first."
      return
    end
    @colour_schemes = ColourScheme.all
  end

  def create
    sanitise_params_for_mgmt_system!
    @system = System.new(params[:system])


    if @system.save
      redirect_to management_systems_path, :notice => "The System was successfully created."
    else
      @colour_schemes = ColourScheme.all
      render :new
    end
  end

  def update
    sanitise_params_for_mgmt_system!
    if @system.update_attributes(params[:system])
      redirect_to system_path(@system), :notice => "The System was successfully updated."
    else
      @colour_schemes = ColourScheme.all
      render :edit
    end
  end

  def index

    #@inactive_systems = System.inactive.all
    #@active_systems = System.active.all
  end

  def activate
    @system.activate!
    redirect_to management_systems_path, :notice => "The System was successfully activated."
  end

  def deactivate
    @system.deactivate!
    redirect_to management_systems_path, :notice => "The System was successfully deactivated."
  end

  def destroy
    if @system.is_active?
      redirect_to :back, :alert => "The system #{@system.name} is active could not be deleted. Deactivate it first."
      return
    end

    if @system.destroy
      redirect_to systems_url, :notice => "The system #{@system.name} has been successfully removed."
    else
      redirect_to :back, :alert => "The system #{@system.name} could not be deleted."
    end
  end

  def export_structure
    #Tenacity breaks the :include directives. normal methods just won't work.
    render :status => :not_implemented
    #respond_to :json
    #
    #render :json => System.all

  end

  def export_data
    #Tenacity breaks the :include directives. normal methods just won't work.
    render :status => :not_implemented

    #objects = Array.new
    #@system.data_objects.each do |dobj|
    #  objects << dobj.to_xml(:include => {
    #                      :data_object_attributes => {},
    #                      :data_object_rows => {},
    #                      :import_mappings => {}
    #                      }
    #                     )
    #end
    #
    #data = @system.to_xml(:include => {
    #    :data_objects => {:include => {
    #                        :data_object_attributes => {},
    #                        :data_object_rows => {},
    #                        :import_mappings => {}
    #                        }
    #                      },
    #    :storage_locations => {},
    #    :file_types => {}
    #})


    #render :xml => data
    #render :file => @system.to_yaml, content_type => 'text/yaml'
  end

  private

  def sanitise_params_for_mgmt_system!
    params.delete(:member)
    params[:member_ids] = [] if params[:member_ids].blank?
    members = params.delete(:member_ids)
    Rails.logger.debug "New user_ids = " + members.to_s unless Rails.env.production?
    Rails.logger.debug params[:system].inspect unless Rails.env.production?
    if members
      params[:system][:administrator_ids] = members
    else
      params[:system][:administrator_ids] = []
    end
  end


end
