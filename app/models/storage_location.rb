class StorageLocation < ActiveRecord::Base
  belongs_to :system
  has_many :file_types
end
