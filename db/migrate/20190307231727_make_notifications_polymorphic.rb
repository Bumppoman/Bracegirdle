class MakeNotificationsPolymorphic < ActiveRecord::Migration[5.2]
  def change
    rename_column :notifications, :model_id, :object_id
    rename_column :notifications, :model_type, :object_type
  end
end
