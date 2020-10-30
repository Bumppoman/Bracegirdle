class AddTrusteeToRulesApprovals < ActiveRecord::Migration[6.0]
  def change
    add_reference :rules_approvals, :trustee
  end
end
