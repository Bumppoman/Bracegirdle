class AddColumnsToContractor < ActiveRecord::Migration[6.0]
  def change
    rename_column :contractors, :address, :street_address
    rename_column :contractors, :phone, :city
    change_column :contractors, :city, :string
    add_column :contractors, :state, 'char(2)'
    add_column :contractors, :zip, 'char(5)'
    add_column :contractors, :phone, :string
    add_column :contractors, :county, :integer
    add_column :contractors, :active, :boolean
  end
end
