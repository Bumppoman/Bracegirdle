class ChangeCemeterySignToBoolean < ActiveRecord::Migration[5.2]
  def change
    change_column :cemetery_inspections, :sign, :boolean
  end
end
