# Read about factories at http://github.com/thoughtbot/factory_girl

#field :name,            :type => String
#field :label,           :type => String
#field :attribute_type,  :type => String
#field :options,         :type => String
#field :length,          :type => Integer
#field :column,          :type => Integer
#field :sort_order,      :type => Integer
#field :required,        :type => Boolean,       :default => false
#field :is_id,           :type => Boolean,       :default => false
#field :editable,        :type => Boolean,       :default => true
#field :visible,         :type => Boolean,       :default => false


FactoryGirl.define do
  factory :data_object_attribute do


      association :data_object

      name "MyString"
      label "MyString"
      attribute_type "String"
      length 1
      required false
      is_id false
      editable false
      column 1
    end
end