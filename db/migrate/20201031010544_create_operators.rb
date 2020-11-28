class CreateOperators < ActiveRecord::Migration[6.0]
  def change
    create_table :operators do |t|
      t.string :crematory_cemid, type: :varchar, limit: 5
      t.string :name
      t.date :certification_date
      t.date :certification_expiration_date
      t.text :notes
      t.boolean :active
      t.date :deactivation_date
      t.string :sort_name
    end
    
    add_foreign_key :operators, :crematories, column: :crematory_cemid, primary_key: :cemid
  end
end
