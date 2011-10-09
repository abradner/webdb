class UsersController < ApplicationController

  respond_to :json, :only => [:list]
  respond_to :html, :except => [:list]

  before_filter :authenticate_user!
  load_and_authorize_resource

  def index
    @users = User.deactivated_or_approved
  end

  def show
  end

  def admin

  end

  def list
    respond_to do |f|
      f.json do
        q = params[:term]
        if q.blank?
          render :json => nil and return
        end
        potential_members = User.potential_members(q)
        #potential_members.delete_if { |user| user == current_user }
        users = Array.new
        potential_members.collect do |u|
          users << Hash[:id => u.id, :label => "#{u.first_name} #{u.last_name}", :value => "#{u.first_name} #{u.last_name}"]
        end
        render :json => users
      end
    end
  end

  def access_requests
    @users = User.pending_approval
  end

  def deactivate
    if !@user.check_number_of_superusers(params[:id], current_user.id) 
      redirect_to(@user, :alert => "You cannot deactivate this account as it is the only account with manager privileges.")
    else
      @user.deactivate
      redirect_to(@user, :notice => "The user has been deactivated.")
    end
  end

  def activate
    @user.activate
    redirect_to(@user, :notice => "The user has been activated.")
  end

  def reject
    @user.reject_access_request
    @user.destroy
    redirect_to(access_requests_users_path, :notice => "The access request for #{@user.email} was rejected.")
  end

  def reject_as_spam
    @user.reject_access_request
    redirect_to(access_requests_users_path, :notice => "The access request for #{@user.email} was rejected and this email address will be permanently blocked.")
  end

  def edit_role
    if @user == current_user
      flash.now[:alert] = "You are changing the role of the user you are logged in as."
    elsif @user.rejected?
      redirect_to(users_path, :alert => "Role can not be set. This user has previously been rejected as a spammer.")
    end
    @roles = Role.by_name
  end

  def edit_approval
    @roles = Role.by_name
  end

  def update_role
    if params[:user][:role_id].blank?
        redirect_to(edit_role_user_path(@user), :alert => "Please select a role for the user.")
    else
      @user.role_id = params[:user][:role_id]
      if !@user.check_number_of_superusers(params[:id], current_user.id)
        redirect_to(edit_role_user_path(@user), :alert => "Only one superuser exists. You cannot change this role.")
      elsif @user.save
        redirect_to(@user, :notice => "The role for #{@user.email} was successfully updated.")
      end
    end
  end

  def approve
    if !params[:user][:role_id].blank?
      @user.role_id = params[:user][:role_id]
      @user.save
      @user.approve_access_request

      redirect_to(access_requests_users_path, :notice => "The access request for #{@user.email} was approved.")
    else
      redirect_to(edit_approval_user_path(@user), :alert => "Please select a role for the user.")
    end
  end
end
