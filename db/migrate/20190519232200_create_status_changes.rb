class CreateStatusChanges < ActiveRecord::Migration[6.0]
  def change
    create_table :status_changes do |t|
      t.integer :statable_id
      t.string :statable_type
      t.timestamps
    end
  end
end
