class RawFilesController < AjaxGenericController

  load_and_authorize_resource :file_type
  load_resource :raw_file

  def index
    @raw_file = RawFile.new(:file_type_id => @file_type.id)
  end

  def edit
    #TODO
  end

  def edit_metadata
    #TODO
  end

  def manage_versions
    #TODO
  end



  # This method uses the model to prepare the file. It should always work.
  # It has been left in for future releases
    #def collect
    #  file = @raw_file.open_file
    #  render :status => :not_found unless file
    #  send_data file, :filename => @raw_file.name
    #end
  
  # This  method is more optimised to use send_file for FS records
  def collect
      file_path = File.join(@raw_file.cached_path, @raw_file.name)
      begin
        case @raw_file.cached_storage_location
          when AppConfig.file_locations.database
            gridfs_file = Mongo::GridFileSystem.new(Mongoid.database).open(file_path, 'r')
            send_data gridfs_file.read, :filename => @raw_file.name
          when AppConfig.file_locations.filesystem
            send_file file_path, :filename => @raw_file.name
        end
      rescue
        render :status => :not_found
      end
  end


  def create
    @raw_file = RawFile.new(params[:raw_file])
    @raw_file.user = current_user
    @raw_file.file_type = @file_type
    #@raw_file.file_type = @file_type


    if @raw_file.save
      redirect_to system_path(@system), :notice => "File Successfully uploaded to #{@file_type.name}"
    else
      redirect_to :back, :alert => @raw_file.errors.each { |e| e.to_s } #"The file failed to upload. #TODO reason"
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
