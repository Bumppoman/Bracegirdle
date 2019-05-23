class RemoveNotesFromNonComplianceNotice < ActiveRecord::Migration[5.2]
  def change
    remove_column :non_compliance_notices, :notes
  end
end
