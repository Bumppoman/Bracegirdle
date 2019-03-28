class CreateCemeteryInspections < ActiveRecord::Migration[5.2]
  def change
    create_table :cemetery_inspections do |t|
      t.references :cemetery
      t.integer :investigator_id
      t.references :trustee
      t.timestamps
    end
  end
end
