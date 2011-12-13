class DataObjectRow
  # attributes from data object reference

  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :data_object

  validates_presence_of :data_object_id

  validate :id_attrs_present
  validate :required_attrs_present

  def id_attrs_present

    # check all ID attributes are defined

    # Possibly handled by import job? since they can't query without unique attributes
  end

  def required_attrs_present

    if self.data_object

      required_attrs = self.data_object.data_object_attributes.required

      required_attrs.each do |attr|
        if self[attr.name].nil?
          self.errors.add(attr.name, "can't be blank")
        end
      end
    end
    
  end


end

