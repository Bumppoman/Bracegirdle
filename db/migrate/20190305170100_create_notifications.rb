class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|
      t.references :receiver
      t.references :sender
      t.string :model_type
      t.integer :model_id
      t.string :message
      t.text :custom_body
      t.boolean :read
      t.timestamps
    end
  end
end
