class SystemsController < ApplicationController
  before_filter :systems_and_memberships #, :only => [:show, :index, :list_administrators, :list_collaborators, :list_members]
  load_and_authorize_resource :system

  def index
    redirect_to pages_home_path
  end

  def show
  end

  def edit_members
  end

  def update_members
    #TODO remove admins from the list of user ids
    if @system.update_attribute(:collaborator_ids, params[:member_ids])
      redirect_to management_systems_path, :notice => "The users of this system were updated."
    else
      render :edit_members
    end
  end

  def list_members
    respond_to do |f|
      f.json { render :json => build_pool(@system.members) }
    end
  end

  def list_administrators
    respond_to do |f|
      f.json { render :json => build_pool(@system.administrators) }
    end
  end

  def list_collaborators
    respond_to do |f|
      f.json { render :json => build_pool(@system.collaborators) }
    end
  end

  private

  def build_pool(user_collection)
    users = Array.new
    term = params[:term].downcase

    return users if user_collection.blank? || term.blank?

    user_collection.collect do |u|
      if u.first_name.downcase.start_with?(term) || u.last_name.downcase.start_with?(term)
        users << Hash[:id => u.id, :label => "#{u.first_name} #{u.last_name}", :value => "#{u.first_name} #{u.last_name}"]
      end
    end
    users
  end


end
