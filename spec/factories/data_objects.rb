#t_belongs_to :system
#
#field :name,              :type => String
#field :description,       :type => String
#field :short_description, :type => String
#field :display_columns,   :type => Integer
#field :is_active,         :type => Boolean

FactoryGirl.define do
  factory :data_object do
    association :system
    sequence(:name) { |n| "Data Object_#{n}" }
    description "Long Description"
    short_description "Short Desc"
    display_columns 1
    is_active false
    end
end