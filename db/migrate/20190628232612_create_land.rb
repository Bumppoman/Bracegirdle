class CreateLand < ActiveRecord::Migration[6.0]
  def change
    create_table :land do |t|
      t.integer :application_type
      t.references :cemetery
      t.integer :investigator_id
      t.string :identifier
      t.integer :status, default: 1
      t.string :trustee_name
      t.integer :trustee_position
      t.date :submission_date
      t.decimal :amount, precision: 9, scale: 2
    end
  end
end
