class RawFilesController < AjaxGenericController

  load_and_authorize_resource :file_type
  load_resource :raw_file

  def index
    @raw_file = RawFile.new
  end

  def create
    @raw_file = RawFile.new(params[:raw_file])
    @raw_file.user = current_user
    #@raw_file.file_type = @file_type


    if @raw_file.save
      redirect_to system_path(@system), :notice => "File Successfully uploaded to #{@file_type.name}"
    else
      redirect_to :back, :alert => @raw_file.errors.each {|e| e.to_s} #"The file failed to upload. #TODO reason"
    end
  end

  private


  #def update
  #  if @storage.update_attributes(params[:raw_storage_container])
  #    redirect_to management_storages_path, :notice => "The storage location  was successfully updated."
  #  else
  #    render :edit
  #  end
  #end


end
