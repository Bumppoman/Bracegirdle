class ChangeUserForeignKeyOnNonComplianceNotices < ActiveRecord::Migration[5.2]
  def change
    rename_column :non_compliance_notices, :user_id, :investigator_id
  end
end
