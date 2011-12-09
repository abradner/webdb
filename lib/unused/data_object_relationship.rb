#class DataObjectRelationship < ActiveRecord::Base
#  belongs_to :data_object
#  belongs_to :relative, :foreign_key => "relative_id", :class_name => "DataObject"
#
#  validates_uniqueness_of :relative_id, :scope => :data_object_id
#  validates_presence_of :relative_id
#  validates_presence_of :data_object_id
#
#  #updated_by
#end
