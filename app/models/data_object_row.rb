class DataObjectRow
  # attributes from data object reference

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :data_object
  

  validate :id_attrs_present
  validate :required_attrs_present

  #TODO validate unique fields defined

  def id_attrs_present

  end

  def required_attrs_present

  end



end

