class ChangeTimesForStatusChanges < ActiveRecord::Migration[6.0]
  def change
    add_column :status_changes, :left_at, :timestamp
    add_column :status_changes, :initial, :boolean
    add_column :status_changes, :final, :boolean
  end
end
