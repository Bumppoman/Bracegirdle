class CreateRules < ActiveRecord::Migration[6.0]
  def change
    create_table :rules do |t|
      t.references :rules_approvals
      t.string :cemetery_cemid, limit: 5
      t.date :approval_date
    end
    
    add_foreign_key :rules, :cemeteries, column: :cemetery_cemid, primary_key: :cemid
  end
end
