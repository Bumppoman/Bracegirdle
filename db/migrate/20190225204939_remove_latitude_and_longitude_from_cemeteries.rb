class RemoveLatitudeAndLongitudeFromCemeteries < ActiveRecord::Migration[5.2]
  def change
    remove_column :cemeteries, :latitude
    remove_column :cemeteries, :longitude
  end
end
