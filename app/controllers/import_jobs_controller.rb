class ImportJobsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :only => [:index, :show]

  load_and_authorize_resource :system
  load_and_authorize_resource :data_object
  load_resource :import_job
  #load_and_authorize_resource :import_job


  def index

  end

  def show
  end

  def import_data
    
    if @import_job.can_import
      @import_job.import
      redirect_to system_data_object_import_job_path(@system, @data_object, @import_job), :notice => "Data is being imported into the data object now"
    else
      redirect_to system_data_object_import_job_path(@system, @data_object, @import_job), :alert => "The raw file in this import job is invalid and cannot be imported"
    end

  end

  def validate

  end

  def create

  end

  def new
    
  end
end
