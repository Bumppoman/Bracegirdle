class AddComplainantInformationToComplaints < ActiveRecord::Migration[5.2]
  def change
    add_column :complaints, :complainant_name, :string
    add_column :complaints, :complainant_address, :string
    add_column :complaints, :complainant_phone, :string
    add_column :complaints, :complainant_email, :string
  end
end
