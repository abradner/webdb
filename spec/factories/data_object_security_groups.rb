# Read about factories at http://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :data_object_security_group do
      security_group_id 1
      data_object_id 1
      read false
      write false
      admin false
    end
end