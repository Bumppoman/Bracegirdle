class AddDescriptionToAttachments < ActiveRecord::Migration[5.2]
  def change
    add_column :attachments, :description, :string, after: :user_id
  end
end
