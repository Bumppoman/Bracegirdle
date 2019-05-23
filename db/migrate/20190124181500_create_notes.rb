class CreateNotes < ActiveRecord::Migration[5.2]
  def change
    create_table :notes do |t|
      t.references :notable, polymorphic: true, index: true
      t.references :user
      t.text :body
      t.timestamps
    end
  end
end
