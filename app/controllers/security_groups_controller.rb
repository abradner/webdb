class SecurityGroupsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :only => [:index, :new, :create, :show, :edit, :update] #TODO remove the viewless actions

  load_and_authorize_resource :system
  load_and_authorize_resource :security_group, :through => :system
  #load_and_authorize_resource :data_object, :through => :system

  def new
  end

  def create
    sanitise_params_for_sec_group!
    if @security_group.save
      redirect_to system_security_group_path(@system, @security_group), :notice => "The Security Group has been created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    sanitise_params_for_sec_group!
    if @security_group.update_attributes(params[:security_group])
      redirect_to system_security_group_path(@system, @security_group), :notice => "The Security Group has been updated."
    else
      render :edit
    end
  end

  def destroy
    if @security_group.destroy
      redirect_to system_security_groups_path(@system), :notice => "The security group #{@security_group.name} has been successfully removed."
    else
      redirect_to :back, :alert => "The security group #{@security_group.name} could not be deleted."
    end

  end

  def show
  end

  def index
    @security_groups = SecurityGroup.all
  end

  private

  def sanitise_params_for_sec_group!
    params.delete(:member)
    params[:member_ids] = [] if params[:member_ids].blank?
    members = params.delete(:member_ids)
    Rails.logger.debug "New user_ids = " + members.to_s unless Rails.env.production?
    if members
      params[:security_group][:user_ids] = members
    else
      params[:security_group][:user_ids] = []
    end
  end

end
