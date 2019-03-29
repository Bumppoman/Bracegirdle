class ChangeTrusteeFieldsOnCemeteryInspection < ActiveRecord::Migration[5.2]
  def change
    remove_column :cemetery_inspections, :trustee_id
    add_column :cemetery_inspections, :trustee_name, :string
    add_column :cemetery_inspections, :trustee_position, :integer
    add_column :cemetery_inspections, :trustee_street_address, :string
    add_column :cemetery_inspections, :trustee_city, :string
    add_column :cemetery_inspections, :trustee_state, :string
    add_column :cemetery_inspections, :trustee_zip, :string
  end
end
