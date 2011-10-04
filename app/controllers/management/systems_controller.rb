class Management::SystemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships

  def new
    @system = System.new
  end
  def edit
    @system = System.find(params[:id])
  end

  def create
    sanitise_params_for_system!
    @system = System.new(params[:system])
      if @system.save
        redirect_to management_systems_path, :notice => "The System was successfully created."
      else
        render :new
      end
    end

  def update
    @system = System.find(params[:id])
    sanitise_params_for_system!

    if @system.update_attributes(params[:system])
      redirect_to system_path(@system), :notice => "The System was successfully updated."
    else
      render :edit
    end
  end
  
  def index
  end

  def destroy
    @system = System.find(params[:id])
    if @system.destroy
      redirect_to systems_url, :notice => "The system #{@system.name} has been successfully removed."
    else
      redirect_to :back, :alert => "The system #{@system.name} could not be deleted."
    end
  end

  private

  def sanitise_params_for_system!
    params.delete(:member)
    params[:system][:member_ids] = [] if params[:system][:member_ids].blank?
    members = params[:system].delete(:member_ids)

    if members
      params[:system][:administrator_ids] = members
    else
      params[:system][:administrator_ids] = []
    end
  end


end
