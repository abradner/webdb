class StorageLocation < ActiveRecord::Base
  include Tenacity
  belongs_to :system
  t_has_many :file_types, :dependent => :destroy

  validates :name, :presence => true
  validates :system_id, :presence => true
#  validates :location, :presence => true, :unless => {:storage_type => :}
  validates_uniqueness_of :name, :case_sensitive => false, :scope => :system_id, :message => "has been taken in this system"
  validates_length_of :name, :maximum => 255

  before_validation do
    name.strip! if name
  end


end
