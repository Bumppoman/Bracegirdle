class AddStatusToStatusChanges < ActiveRecord::Migration[6.0]
  def change
    rename_column :status_changes, :created_at, :status_id
    rename_column :status_changes, :updated_at, :created_at
    change_column :status_changes, :status_id, :integer
  end
end
