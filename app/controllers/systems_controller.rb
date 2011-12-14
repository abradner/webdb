class SystemsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :except => [:select_raw_file_type]
  load_and_authorize_resource :system
  respond_to :js, :only => [:select_raw_file_type]


  def index
    redirect_to pages_home_path
  end

  def show
    flash_message :notice, "Warning: System is inactive and in read-only mode." unless @system.is_active?

    #Workaround for scopes not working through tenacity associations (me cries. well, it's probably faster)
    if @system.data_objects.present?
      @active_data_objects = Array.new
      @inactive_data_objects = Array.new
      @system.data_objects.each do |dobj|
        dobj.is_active? ? @active_data_objects << dobj :
                          @inactive_data_objects << dobj
      end
    end

  end

  def edit_members
    unless @system.is_active?
      redirect_to :back, :alert => "The system #{@system.name} is inactive and cannot be changed. Reactivate it first."
    end
  end

  def configure;
  end

  def select_raw_file_type
    if (ft = params[:file_type_id]).present?
      @file_type = FileType.find(ft)
      #redirect_to new_system_file_type_raw_file_path(@system, ft)
    end
  end

  def update_members
    unless @system.is_active?
      redirect_to :back, :alert => "The system #{@system.name} is inactive and cannot be changed. Reactivate it first."
      return
    end
    #TODO remove admins from the list of user ids
    if @system.update_attribute(:collaborator_ids, params[:member_ids])
      redirect_to @system, :notice => "The users of this system were updated."
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
