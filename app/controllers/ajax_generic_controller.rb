class AjaxGenericController < ApplicationController
  respond_to :js

  before_filter :authenticate_user!

  load_and_authorize_resource :system

  def new; end
  def edit; end
  def index; end

end
