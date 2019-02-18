class ChangeUserColumnsOnRules < ActiveRecord::Migration[5.2]
  def change
    remove_column :rules, :accepted_by_id
    rename_column :rules, :approved_by_id, :investigator_id
  end
end
