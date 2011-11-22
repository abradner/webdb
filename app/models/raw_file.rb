require 'carrierwave/mongoid'

class RawFile
  include Mongoid::Document
  include Mongoid::Timestamps
  include Tenacity


  t_belongs_to :user
  belongs_to :file_type
  embeds_one :file_metadata
  mount_uploader :stored_file, RawStorageUploader

  validates_presence_of :user_id

  before_save :update_asset_attributes

  private

  def update_asset_attributes
    #if raw_file.present? && raw_file_changed?
    #
    #  if self.file_metadata.blank? #TODO this is really hacky
    #    @meta = FileMetadata.new(:filename => raw_file.file.filename, :size => raw_file.file.size)
    #    @meta.raw_storage_container = self
    #    self.file_metadata = @meta
    #  else
    #    self.file_metadata.filename = raw_file.file.filename
    #    self.file_metadata.size = raw_file.file.size
    #  end
    #  self.file_metadata.save!
    #end
  end

end
