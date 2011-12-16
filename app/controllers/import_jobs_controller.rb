class ImportJobsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :only => [:index, :show]

  load_and_authorize_resource :system
  load_and_authorize_resource :data_object
  load_and_authorize_resource :import_job, :through => :data_object


  def index

  end

  def show
  end

  def import_data

    if @import_job.can_import
      @import_job.update_attribute(:status, "Import requested")
      @import_job.import
      redirect_to system_data_object_import_jobs_path(@system, @data_object), :notice => "Data is being imported into the data object now"
    else
      redirect_to system_data_object_import_jobs_path(@system, @data_object), :alert => "The raw file in the import job is invalid and cannot be imported"
    end

  end

  def validate
    if !@import_job.validated
      @import_job.update_attribute(:status, "Validation requested")
      @import_job.validate_file
      redirect_to system_data_object_import_jobs_path(@system, @data_object), :notice => "The import job is being validated now"
    else
      redirect_to system_data_object_import_jobs_path(@system, @data_object), :alert => "The import job has been validated already"
    end

  end

  def reset
    @import_job.reset
    redirect_to system_data_object_import_jobs_path(@system, @data_object), :notice => "The import job has been reset"
  end

  def create

  end

  def new

  end
end
