class Management::ColourSchemesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :only => [:show, :index]

  load_and_authorize_resource :colour_scheme

  layout 'management'

  def index
    @colour_schemes = ColourScheme.all
  end
  
  def new
  end

  def edit
  end

  def create
    if @colour_scheme.save
      redirect_to management_colour_schemes_path, :notice => "The colour scheme was successfully created."
    else
      render :new
    end
  end
end
