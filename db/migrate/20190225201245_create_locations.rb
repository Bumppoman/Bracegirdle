class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.integer :locatable_id
      t.string :locatable_type
      t.float :latitude
      t.float :longitude
    end
  end
end
