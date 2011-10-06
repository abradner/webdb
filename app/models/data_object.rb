class DataObject < ActiveRecord::Base
  #has_and_belongs_to_many :file_data_types
  #has_many :custom_fields  # the builder could be smart - custom fields can be suggested from existing templates
  #has_one  :file_system, :dependent => :destroy
  belongs_to :system

  validates :name, :presence => true
  validates_uniqueness_of :name, :case_sensitive => false, :scope => :system_id, :message => "has been taken in this system"
  validates :short_description, :presence => true
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 5000
  validates_length_of :short_description, :maximum => 512

  before_validation do
    name.strip! if name
  end

end
