class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.integer :notable_id
      t.string :notable_type
      t.references :user
      t.text :body
      t.references :notable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
