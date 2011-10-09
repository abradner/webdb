class Management::SystemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships

  load_and_authorize_resource :system

  def new
    @colour_schemes = ColourScheme.all
  end
  def edit
    @colour_schemes = ColourScheme.all
  end

  def create
    sanitise_params_for_system!
    @system = System.new(params[:system])

    if @system.save
      redirect_to management_systems_path, :notice => "The System was successfully created."
    else
      @colour_schemes = ColourScheme.all
      render :new
    end
  end

  def update
    sanitise_params_for_system!

    if @system.update_attributes(params[:system])
      redirect_to system_path(@system), :notice => "The System was successfully updated."
    else
      @colour_schemes = ColourScheme.all
      render :edit
    end
  end
  
  def index
  end

  def destroy
    if @system.destroy
      redirect_to systems_url, :notice => "The system #{@system.name} has been successfully removed."
    else
      redirect_to :back, :alert => "The system #{@system.name} could not be deleted."
    end
  end

  private

  def sanitise_params_for_system!
    params.delete(:member)
    params[:member_ids] = [] if params[:member_ids].blank?
    members = params.delete(:member_ids)
    Rails.logger.debug "New user_ids = " + members.inspect unless Rails.env.production?
    if members
      params[:system][:administrator_ids] = members
    else
      params[:system][:administrator_ids] = []
    end
  end


end
