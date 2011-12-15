# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20111215005855) do

  create_table "colour_schemes", :force => true do |t|
    t.string   "name"
    t.string   "banner",     :limit => 6
    t.string   "background", :limit => 6
    t.string   "body",       :limit => 6
    t.string   "h1",         :limit => 6
    t.string   "h2",         :limit => 6
    t.string   "h3",         :limit => 6
    t.string   "a",          :limit => 6
    t.string   "a_visited",  :limit => 6
    t.string   "a_active",   :limit => 6
    t.string   "a_hover",    :limit => 6
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "permissions", :force => true do |t|
    t.string   "entity"
    t.string   "action"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_permissions", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "permission_id"
  end

  create_table "security_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "short_description", :limit => 512
    t.integer  "system_id"
  end

  create_table "system_members", :id => false, :force => true do |t|
    t.integer  "system_id",                        :null => false
    t.integer  "user_id",                          :null => false
    t.boolean  "administrator", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "system_members", ["system_id"], :name => "altered_system_members_system_id_index"

  create_table "systems", :force => true do |t|
    t.string   "name"
    t.string   "code",             :limit => 12
    t.integer  "colour_scheme_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description",      :limit => 255
    t.boolean  "is_active",                       :default => false, :null => false
    t.string   "schema_name"
  end

  create_table "user_security_groups", :id => false, :force => true do |t|
    t.integer  "user_id",           :null => false
    t.integer  "security_group_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_security_groups", ["user_id"], :name => "user_security_groups_user_id_index"

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "", :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.integer  "failed_attempts",                       :default => 0
    t.datetime "locked_at"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "status"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
