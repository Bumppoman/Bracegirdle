class AddDirectionalSignsToCemeteryInspection < ActiveRecord::Migration[6.0]
  def change
    add_column :cemetery_inspections, :directional_signs_required, :boolean
    add_column :cemetery_inspections, :directional_signs_present, :boolean
    add_column :cemetery_inspections, :directional_signs_comments, :text
  end
end
