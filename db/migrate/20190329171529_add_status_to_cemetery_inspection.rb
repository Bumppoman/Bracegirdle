class AddStatusToCemeteryInspection < ActiveRecord::Migration[5.2]
  def change
    add_column :cemetery_inspections, :status, :integer
  end
end
