class SplitAddressForTrustees < ActiveRecord::Migration[5.2]
  def change
    rename_column :trustees, :address, :street_address
    add_column :trustees, :city, :string
    add_column :trustees, :state, :string
    add_column :trustees, :zip, :integer
  end
end
