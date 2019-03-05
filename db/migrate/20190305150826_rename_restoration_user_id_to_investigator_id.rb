class RenameRestorationUserIdToInvestigatorId < ActiveRecord::Migration[5.2]
  def change
    rename_column :restoration, :user_id, :investigator_id
  end
end
