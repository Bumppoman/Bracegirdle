class CreateRules < ActiveRecord::Migration[5.2]
  def change
    create_table :rules do |t|
      t.references :cemetery
      t.date :submission_date
      t.date :approval_date
      t.string :file_name
      t.timestamps
    end
  end
end
