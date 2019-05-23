class RenameVandalismsToVandalism < ActiveRecord::Migration[5.2]
  def change
    rename_table :vandalisms, :vandalism
  end
end
