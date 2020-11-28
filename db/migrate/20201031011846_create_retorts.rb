class CreateRetorts < ActiveRecord::Migration[6.0]
  def change
    create_table :retorts do |t|
      t.string :crematory_cemid, type: :varchar, limit: 5
      t.references :retort_model
      t.date :installation_date
      t.date :decommission_date
      t.text :notes
      t.boolean :active
    end
    
    add_foreign_key :retorts, :crematories, column: :crematory_cemid, primary_key: :cemid
  end
end
