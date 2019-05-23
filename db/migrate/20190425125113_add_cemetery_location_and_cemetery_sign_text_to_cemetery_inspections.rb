class AddCemeteryLocationAndCemeterySignTextToCemeteryInspections < ActiveRecord::Migration[5.2]
  def change
    add_column :cemetery_inspections, :cemetery_location, :text
    add_column :cemetery_inspections, :cemetery_sign_text, :string
  end
end
