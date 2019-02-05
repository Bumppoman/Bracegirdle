class AddStatusToRules < ActiveRecord::Migration[5.2]
  def change
    add_column :rules, :status, :integer, default: 1
  end
end
