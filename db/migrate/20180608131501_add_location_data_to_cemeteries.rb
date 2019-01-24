class AddLocationDataToCemeteries < ActiveRecord::Migration[5.2]
  def change
    add_column :cemeteries, :latitude, :float, after: :order_id, null: true, precision: 10, scale: 6
    add_column :cemeteries, :longitude, :float, after: :latitude, null: true, precision: 10, scale: 6
  end
end
