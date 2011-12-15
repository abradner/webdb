class Management::ImportJobsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :only => [:show, :index]

  load_and_authorize_resource :import_job

  layout 'management'

  def index
    @colour_schemes = ColourScheme.all
  end

end
