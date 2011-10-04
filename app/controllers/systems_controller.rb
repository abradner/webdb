class SystemsController < ApplicationController

  before_filter :systems_and_memberships, :only => [:show, :index]

  def index
    redirect_to pages_home_path
  end

  def show
    @system = System.find(params[:id])
  end
end
