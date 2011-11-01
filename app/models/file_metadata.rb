class FileMetadata
  include Mongoid::Document
  include Mongoid::Timestamps

  field :filename, :type => String
  field :size, :type => String

  embedded_in :raw_storage_container
  validates_presence_of :filename, :size
end
