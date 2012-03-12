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
  ATTRIBUTE_TYPES = AppConfig.attribute_types.keys

  factory :data_object_attribute do

    #ATTRIBUTE_TYPES[rand(ATTRIBUTE_TYPES.length-1)]
    association :data_object
    sequence(:name) { |n| "attr_#{n}" }
    sequence(:label) { |n| "Attribute #{n}" }
    attribute_type "String"
    length 40
    required false
    is_id false
    editable true
    visible true
    column 1
    sequence(:sort_order)

    factory(:doa_string) {}

    factory :doa_date do
      sequence(:name) { |n| "date_attr_#{n}" }
      sequence(:label) { |n| "Date Attribute #{n}" }
      attribute_type "Date"
    end

    factory :doa_time do
      sequence(:name) { |n| "time_attr_#{n}" }
      sequence(:label) { |n| "time Attribute #{n}" }
      attribute_type "Time"
    end

    factory :doa_date_time do
      sequence(:name) { |n| "date_time_attr_#{n}" }
      sequence(:label) { |n| "Date/time Attribute #{n}" }
      attribute_type "DateTime"
    end

    factory :doa_char do
      sequence(:name) { |n| "char_attr_#{n}" }
      sequence(:label) { |n| "Character Attribute #{n}" }
      attribute_type "Char"
    end

    factory :doa_text do
      sequence(:name) { |n| "text_attr_#{n}" }
      sequence(:label) { |n| "Text Attribute #{n}" }
      attribute_type "Text"
      length 2048
    end

    factory :doa_int do
      sequence(:name) { |n| "int_attr_#{n}" }
      sequence(:label) { |n| "Integer Attribute #{n}" }
      attribute_type "Integer"
    end

    factory :doa_float do
      sequence(:name) { |n| "float_attr_#{n}" }
      sequence(:label) { |n| "float Attribute #{n}" }
      attribute_type "Float"
    end

    factory :doa_multi do
      sequence(:name) { |n| "multi_attr_#{n}" }
      sequence(:label) { |n| "multi Attribute #{n}" }
      attribute_type "Multi"
      # Todo options
    end

    factory :doa_radio do
      sequence(:name) { |n| "radio_attr_#{n}" }
      sequence(:label) { |n| "Radio Attribute #{n}" }
      attribute_type "Radio"
      # Todo options

    end

    factory :doa_select do
      sequence(:name) { |n| "select_attr_#{n}" }
      sequence(:label) { |n| "Select Attribute #{n}" }
      attribute_type "Select"
      # Todo options

    end
  end
end