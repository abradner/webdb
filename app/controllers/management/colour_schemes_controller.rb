class Management::ColourSchemesController < ApplicationController
  before_filter :systems_and_memberships, :only => [:show, :index]
  def index
    @colour_scheme = ColourScheme.all
  end
  
  def new
    @colour_scheme = ColourScheme.new
  end

  def edit
    @colour_scheme = ColourScheme.find(params[:id])
  end

  def create
    @colour_scheme = ColourScheme.new(params[:colour_scheme])
    if @colour_scheme.save
      redirect_to management_colour_schemes_path, :notice => "The colour scheme was successfully created."
    else
      render :new
    end
  end
end
