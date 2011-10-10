class FileType < ActiveRecord::Base
  belongs_to :system
  belongs_to :storage
  belongs_to :file_content_type
  #TODO security
  has_and_belongs_to_many :data_objects
end
