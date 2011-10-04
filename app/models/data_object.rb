class DataObject < ActiveRecord::Base
  #has_and_belongs_to_many :file_data_types
  #has_many :custom_fields  # the builder could be smart - custom fields can be suggested from existing templates
  #has_one  :file_system, :dependent => :destroy
  belongs_to :system
end
