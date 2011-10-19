# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_object_attribute do
      data_object_id 1
      name "MyString"
      label "MyString"
      type ""
      length 1
      required false
      is_id false
      editable false
      column 1
    end
end