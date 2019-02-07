class RemoveTownIdFromCemeteries < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :cemeteries, :town_id
  end
end
