class AddTownToCemetery < ActiveRecord::Migration[5.2]
  def change
    add_reference :cemeteries, :town, foreign_key: true, after: :order_id
  end
end
