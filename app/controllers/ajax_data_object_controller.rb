class AjaxDataObjectController < ApplicationController
  respond_to :js

  before_filter :authenticate_user!

  load_and_authorize_resource :system
  load_and_authorize_resource :data_object, :through => :system

  def new; end
  def edit; end
  def index; end

  def update
    @errors = true unless @data_object.update_attributes(params[:data_object])
  end

end
