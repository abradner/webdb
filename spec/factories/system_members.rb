FactoryGirl.define do
  factory :system_member do
      association :system
      association :user
      administrator false
    end
end