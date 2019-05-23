class ChangeCemeteryInspectionsUuidToIdentifier < ActiveRecord::Migration[5.2]
  def change
    rename_column :cemetery_inspections, :uuid, :identifier
    change_column :cemetery_inspections, :identifier, :string
  end
end
