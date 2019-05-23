class ChangeUserForeignKeysOnComplaints < ActiveRecord::Migration[5.2]
  def change
    rename_column :complaints, :receiver, :receiver_id
    rename_column :complaints, :investigator, :investigator_id
  end
end
