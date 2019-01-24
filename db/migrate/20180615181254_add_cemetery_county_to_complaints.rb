class AddCemeteryCountyToComplaints < ActiveRecord::Migration[5.2]
  def change
    add_column :complaints, :cemetery_county, :integer, after: :cemetery_alternate_name
  end
end
