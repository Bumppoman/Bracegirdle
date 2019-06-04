class ChangeCemeteryInspectionPetBurialsCommentsToString < ActiveRecord::Migration[6.0]
  def change
    change_column :cemetery_inspections, :pet_burials_comments, :string
  end
end
