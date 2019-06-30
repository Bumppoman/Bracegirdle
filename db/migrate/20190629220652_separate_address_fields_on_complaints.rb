class SeparateAddressFieldsOnComplaints < ActiveRecord::Migration[6.0]
  def change
    add_column :complaints, :complainant_city, :string, after: :complainant_address
    add_column :complaints, :complainant_state, :string, after: :complainant_city
    add_column :complaints, :complainant_zip, :string, after: :complainant_state
    rename_column :complaints, :complainant_address, :complainant_street_address
  end
end