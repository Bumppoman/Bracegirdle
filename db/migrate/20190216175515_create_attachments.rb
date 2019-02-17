class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.integer :attachable_id
      t.string :attachable_type
      t.references :cemetery
      t.references :user
      t.references :attachable, polymorphic: true, index: true
      t.timestamps
    end
  end
end
