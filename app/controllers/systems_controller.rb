class SystemsController < ApplicationController
  before_filter :systems_and_memberships, :only => [:show, :index]
  load_and_authorize_resource :system

  def index
    redirect_to pages_home_path
  end

  def show
  end
end
