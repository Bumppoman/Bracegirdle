class ReplaceRestorationTrusteeIdWithTrusteeNameAndTrusteePosition < ActiveRecord::Migration[5.2]
  def change
    change_column :restoration, :trustee_id, :string
    rename_column :restoration, :trustee_id, :trustee_name
    add_column :restoration, :trustee_position, :integer, after: :trustee_name
  end
end
