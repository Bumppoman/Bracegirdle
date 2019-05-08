class AddDateMailedToCemeteryInspections < ActiveRecord::Migration[5.2]
  def change
    add_column :cemetery_inspections, :date_mailed, :date
  end
end
