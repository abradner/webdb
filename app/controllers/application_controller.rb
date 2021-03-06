class ApplicationController < ActionController::Base
  protect_from_forgery

  #check_authorization #TODO make sure this passes

  layout :layout_by_resource

  def layout_by_resource
    if devise_controller?
      "guest"
    else
      "application"
    end
  end

  # catch access denied and redirect to the home page
  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = exception.message
    Rails.logger.debug "Access denied on #{exception.action}, Details: \n#{exception.subject.inspect}" unless Rails.env.production?

    respond_to do |format|
      format.js { render :partial => 'shared/access_denied_popup'}
      format.all { redirect_to root_path }
    end
  end


  rescue_from ActionView::MissingTemplate do |exception|
    Rails.logger.error exception
    render :file => "#{Rails.root}/public/404.html", :status => 404
  end

  rescue_from ActiveRecord::RecordNotFound do |exception|
    Rails.logger.error exception
    flash[:alert] = exception.message
    redirect_to systems_path
  end

  protected
  def systems_and_memberships
    return unless user_signed_in?

    @memberships = current_user.system_memberships
    @collaborations = current_user.system_collaborations
    @administrations = current_user.system_administrations

    if can? :admin, User
    #  @partial_systems = System.part
      @systems = System.all :order => :name
      @inactive_systems = System.inactive.all
      @active_systems = System.active.all
    end

  end

  def flash_message(type, message)
    if flash[type]
      flash[type] << "\n".html_safe
    else
      flash[type] = []
    end
    flash[type] << message
  end

end
