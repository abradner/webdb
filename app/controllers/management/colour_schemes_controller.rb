class Management::ColourSchemesController < ApplicationController
  before_filter :systems_and_memberships, :only => [:show, :index]
  def index

  end
end
