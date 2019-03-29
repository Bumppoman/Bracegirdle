class RenameCemeteriesLastInspectionToLastInspectionDate < ActiveRecord::Migration[5.2]
  def change
    rename_column :cemeteries, :last_inspection, :last_inspection_date
  end
end
