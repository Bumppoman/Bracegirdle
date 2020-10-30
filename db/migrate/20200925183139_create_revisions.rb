class CreateRevisions < ActiveRecord::Migration[6.0]
  def change
    create_table :revisions do |t|
      t.references :rules_approvals
      t.text :comments
      t.date :submission_date
      t.integer :status, default: 1
      t.datetime :created_at, null: false
    end
  end
end
