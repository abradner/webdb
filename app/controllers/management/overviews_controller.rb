class Management::OverviewsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :systems_and_memberships, :only => [:show, :index]

  layout 'management'

  def index

  end
end
