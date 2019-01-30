class AddDefaultToNonComplianceNoticesStatus < ActiveRecord::Migration[5.2]
  def change
    change_column :non_compliance_notices, :status, :integer, default: 1
  end
end
