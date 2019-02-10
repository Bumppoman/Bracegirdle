class RenameNonComplianceNoticesToNotices < ActiveRecord::Migration[5.2]
  def change
    remove_index :non_compliance_notices, :cemetery_id
    remove_index :non_compliance_notices, :investigator_id
    rename_table :non_compliance_notices, :notices
    add_index :notices, :cemetery_id
    add_index :notices, :investigator_id
  end
end
