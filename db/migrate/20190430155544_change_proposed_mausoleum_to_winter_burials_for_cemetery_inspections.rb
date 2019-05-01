class ChangeProposedMausoleumToWinterBurialsForCemeteryInspections < ActiveRecord::Migration[5.2]
  def change
    rename_column :cemetery_inspections, :proposed_mausoleum, :winter_burials
    rename_column :cemetery_inspections, :proposed_mausoleum_comments, :winter_burials_comments
  end
end
