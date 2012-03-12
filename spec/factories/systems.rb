#belongs_to :colour_scheme

#t.string   "name"
#t.string   "code",             :limit => 12
#t.integer  "colour_scheme_id"
#t.datetime "created_at"
#t.datetime "updated_at"
#t.text     "description",      :limit => 255
#t.boolean  "is_active",                       :default => false, :null => false
#t.string   "schema_name"


FactoryGirl.define do
  factory :system do
    association :colour_scheme
    sequence(:name) { |n| "System #{n}" }
    sequence(:code) { |n| "SYS#{n}" }
    sequence(:schema_name) { |n| "sys_#{n}" }
    description "System Description"
    is_active true
  end
end