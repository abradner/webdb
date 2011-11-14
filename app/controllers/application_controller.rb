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
    redirect_to :back
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
    end

  end



end
