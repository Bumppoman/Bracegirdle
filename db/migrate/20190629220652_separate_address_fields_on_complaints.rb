class SeparateAddressFieldsOnComplaints < ActiveRecord::Migration[6.0]
  def change
    add_column :complaints, :complainant_city, :string, after: :complainant_address
    add_column :complaints, :complainant_state, :string, after: :complainant_city
    add_column :complaints, :complainant_zip, :string, after: :complainant_state

    # Try to split existing addresses
    Complaint.all.each do |complaint|
      matches = /(.*), ([a-zA-Z]*), ([A-Z]{2}) (\d{5})/.match(complaint.complainant_address)
      complaint.update(
        complainant_address: matches[1],
        complainant_city: matches[2],
        complainant_state: matches[3],
        complainant_zip: matches[4]
      )
    end

    # Rename address to street address
    rename_column :complaints, :complainant_address, :complainant_street_address
  end
end
