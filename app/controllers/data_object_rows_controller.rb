class DataObjectRowsController < ApplicationController

  before_filter :authenticate_user!
  before_filter :systems_and_memberships

  load_and_authorize_resource :system
  load_and_authorize_resource :data_object
  load_and_authorize_resource :data_object_row, :through => :data_object

  def edit

  end

  def update
    if @data_object_row.update_attributes(params[:data_object_row])
      redirect_to system_data_object_path(@system, @data_object), :notice => "The data object row was successfully updated."
    else
      render :edit
    end

  end

  def destroy
    if @data_object_row.destroy
      redirect_to system_data_object_path(@system, @data_object), :notice => "The data object row was successfully deleted."
    else
      redirect_to system_data_object_path(@system, @data_object), :alert => "The data object row could not be deleted."

    end
  end


end
