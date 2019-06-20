class ChangeCemeteriesLastAuditToLastAuditDate < ActiveRecord::Migration[6.0]
  def change
    rename_column :cemeteries, :last_audit, :last_audit_date
  end
end
