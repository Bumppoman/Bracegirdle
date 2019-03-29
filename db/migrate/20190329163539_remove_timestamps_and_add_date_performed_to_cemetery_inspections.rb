class RemoveTimestampsAndAddDatePerformedToCemeteryInspections < ActiveRecord::Migration[5.2]
  def change
    remove_column :cemetery_inspections, :created_at
    remove_column :cemetery_inspections, :updated_at
    add_column :cemetery_inspections, :date_performed, :date
  end
end
