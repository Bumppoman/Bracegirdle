class AddCemeteryInformationToCemeteryInspection < ActiveRecord::Migration[5.2]
  def change
    add_column :cemetery_inspections, :trustee_phone, :string
    add_column :cemetery_inspections, :trustee_email, :string
    add_column :cemetery_inspections, :sign, :string
  end
end
