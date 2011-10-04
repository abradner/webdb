class FixSystemMembersUserId < ActiveRecord::Migration
  def change
    rename_column :system_members, :data_object_id, :user_id
  end
end
