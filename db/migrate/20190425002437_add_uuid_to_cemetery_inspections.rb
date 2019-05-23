class AddUuidToCemeteryInspections < ActiveRecord::Migration[5.2]
  def change
    add_column :cemetery_inspections, :uuid, :uuid
  end
end
