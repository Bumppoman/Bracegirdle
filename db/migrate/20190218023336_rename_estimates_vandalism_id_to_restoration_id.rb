class RenameEstimatesVandalismIdToRestorationId < ActiveRecord::Migration[5.2]
  def change
    rename_column :estimates, :vandalism_id, :restoration_id
  end
end
