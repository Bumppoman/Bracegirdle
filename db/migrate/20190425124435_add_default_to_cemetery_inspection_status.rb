class AddDefaultToCemeteryInspectionStatus < ActiveRecord::Migration[5.2]
  def change
    change_column_default :cemetery_inspections, :status, 1
  end
end
