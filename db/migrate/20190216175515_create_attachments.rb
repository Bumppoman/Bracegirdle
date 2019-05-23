class CreateAttachments < ActiveRecord::Migration[5.2]
  def change
    create_table :attachments do |t|
      t.references :attachable, polymorphic: true, index: true
      t.references :cemetery
      t.references :user
      t.timestamps
    end
  end
end
