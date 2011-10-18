# encoding: utf-8

#TODO: READ How to: Make a fast lookup able storage directory structure
#https://github.com/jnicklas/carrierwave/wiki/How-to%3A-Make-a-fast-lookup-able-storage-directory-structure

class RawStorageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def self.use_grid_fs(answer)
    answer ? storage(:grid_fs) : storage(:file)
  end

  def store_dir(path = nil)
    Rails.logger.debug "WARNING: no store_dir set for upload!" if path.blank? && Rails.env.production?
    path || "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end

  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  #def self.use_grid_fs(answer)
  #  answer ? storage(:grid_fs) : storage(:file)
  #end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  #def store_dir(path = nil)
  #  Rails.logger.debug "WARNING: no store_dir set for upload!" if path.blank? && Rails.env.production?
  #  path || "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  #end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :scale => [50, 50]
  # end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  # def extension_white_list
  #   %w(jpg jpeg gif png)
  # end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

