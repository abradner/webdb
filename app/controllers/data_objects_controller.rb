class DataObjectsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :data_objects_and_memberships, :only => [:index]

  def new
    @dobj = DataObject.new
  end

  def create
    @dobj = DataObject.new(params[:system_id])
    if @dobj.save
      redirect_to data_objects_path, :notice => "The Data Object has been created."
    else
      render "pages/home"
    end
  end

  def index

  end
end
