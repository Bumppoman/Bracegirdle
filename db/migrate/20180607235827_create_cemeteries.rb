class CreateCemeteries < ActiveRecord::Migration[5.2]
  def change
    create_table :cemeteries do |t|
      t.string :name
      t.integer :county
      t.integer :order_id
      t.boolean :active
      t.date :last_inspection, null: true
      t.date :last_audit, null: true
    end
  end
end
