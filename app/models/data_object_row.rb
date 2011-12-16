class DataObjectRow
  # attributes from data object reference

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :data_object

  validates_presence_of :data_object_id

  #validate :id_attrs_present
  validate :required_attrs_present

  #ids are required anyway
  def id_attrs_present
    if self.data_object

      id_attrs = self.data_object.data_object_attributes.is_id

      id_attrs.each do |attr|

        if self[attr.name].blank?
          self.errors.add(attr.label, "can't be blank")
        end
      end
    end
  end

  def required_attrs_present

    if self.data_object

      required_attrs = self.data_object.data_object_attributes.required

      required_attrs.each do |attr|
        if self[attr.name].blank?
          self.errors.add(attr.label, "can't be blank")
        end
      end
    end
    
  end


end

