class PagesController < ApplicationController
  before_filter :systems_and_memberships, :only => [:routing_error, :home]

  layout 'overview'

  def home
    render :layout => 'guest' and return unless user_signed_in?

    if @memberships.count.eql?(1)
      redirect_to system_path(@memberships.first)
    end

  end

  def helper

    case params[:selected_helper]
      when "time"
        page = 'shared/helpers/time'
      when "regex"
        page = 'shared/helpers/regex'
      else
        page = "#{Rails.root}/public/404.html"
    end
    render page, :layout => nil
  end

  def routing_error
     render :file => "#{Rails.root}/public/404.html", :status => 404
   end

end
