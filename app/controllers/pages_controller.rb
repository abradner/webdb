class PagesController < ApplicationController
  before_filter :systems_and_memberships, :only => [:home, :routing_error]

  def home
  end

  def routing_error
     render :file => "#{Rails.root}/public/404.html", :status => 404
   end

end
