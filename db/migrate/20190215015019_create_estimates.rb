class CreateEstimates < ActiveRecord::Migration[5.2]
  def change
    create_table :estimates do |t|
      t.references :vandalism
      t.integer :contractor_id
      t.decimal :amount, precision: 9, scale: 2
      t.timestamps
    end
  end
end
