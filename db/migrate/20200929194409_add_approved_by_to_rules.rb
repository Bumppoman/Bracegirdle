class AddApprovedByToRules < ActiveRecord::Migration[6.0]
  def change
    add_belongs_to :rules, :approved_by, foreign_key: { to_table: :users }
  end
end
