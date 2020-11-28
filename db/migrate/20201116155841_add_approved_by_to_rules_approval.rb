class AddApprovedByToRulesApproval < ActiveRecord::Migration[6.0]
  def change
    add_column :rules_approvals, :approved_by_id, :integer
    add_foreign_key :rules_approvals, :users, column: :approved_by_id
    add_index :rules_approvals, :approved_by_id
  end
end
