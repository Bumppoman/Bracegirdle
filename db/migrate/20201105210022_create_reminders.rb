class CreateReminders < ActiveRecord::Migration[6.0]
  def change
    create_table :reminders do |t|
      t.references :user, foreign_key: true
      t.string :title
      t.text :details
      t.datetime :created_at, null: false
      t.datetime :due_date
      t.boolean :completed, default: false
    end
  end
end
