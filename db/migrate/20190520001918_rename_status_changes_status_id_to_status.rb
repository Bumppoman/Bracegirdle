class RenameStatusChangesStatusIdToStatus < ActiveRecord::Migration[6.0]
  def change
    rename_column :status_changes, :status_id, :status
  end
end
