class PagesController < ApplicationController
  before_filter :systems_and_memberships, :only => [:home]

  def home
  end

  def routing_error
     render :file => "#{Rails.root}/public/404.html", :status => 404
   end

end
