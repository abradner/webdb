class Storage < ActiveRecord::Base
  has_many :systems
  has_many :file_types
end
