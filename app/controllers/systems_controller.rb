class SystemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :except => [:select_raw_file_type]
  load_and_authorize_resource :system
  respond_to :js, :only => [:select_raw_file_type]


  def index
    redirect_to pages_home_path
  end

  def show;end
  def edit_members; end
  def manage;  end

  def select_raw_file_type
    if (ft = params[:file_type_id]).present?
      @file_type = FileType.find(ft)
      #redirect_to new_system_file_type_raw_file_path(@system, ft)
    end
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
