class AddPetBurialsToCemeteryInspections < ActiveRecord::Migration[6.0]
  def change
    add_column :cemetery_inspections, :pet_burials, :boolean, after: :trustees_compensated_comments
    add_column :cemetery_inspections, :pet_burials_comments, :boolean, after: :pet_burials
  end
end
