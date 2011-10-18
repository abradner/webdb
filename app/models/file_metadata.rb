class FileMetadata
  include Mongoid::Document
  include Mongoid::Timestamps

  field :filename, :type => String
  field :size, :type => String

  validates_presence_of :filename, :size
end
