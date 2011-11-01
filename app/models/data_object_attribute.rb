class DataObjectAttribute < ActiveRecord::Base
  #updated_by
  belongs_to :data_object

  validates :name, :presence => true #, :if => Proc.new { |d| d.is_active?}
  validates_uniqueness_of :name, :case_sensitive => false, :scope => :data_object_id, :message => "has been taken in this data object"
  validates_length_of :name, :maximum => 45
  validates_length_of :label, :maximum => 255

end
