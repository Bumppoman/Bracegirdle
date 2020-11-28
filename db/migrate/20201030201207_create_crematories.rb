class CreateCrematories < ActiveRecord::Migration[6.0]
  def change
    create_table :crematories, id: false do |t|
      t.string :cemid, limit: 5, primary_key: true
      t.string :name
      t.integer :county
      t.string :street_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :email
      t.integer :investigator_region
      t.integer :esd_region
      t.integer :classification
      t.boolean :active, default: true
      t.date :last_inspection_date
      t.date :last_audit_date
    end
  end
end
