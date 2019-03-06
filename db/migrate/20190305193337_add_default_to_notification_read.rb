class AddDefaultToNotificationRead < ActiveRecord::Migration[5.2]
  def change
    change_column :notifications, :read, :boolean, default: false
  end
end
