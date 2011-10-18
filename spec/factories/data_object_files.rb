# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_object_file do
      data_object_id 1
      raw_storage_container_id "MyString"
    end
end