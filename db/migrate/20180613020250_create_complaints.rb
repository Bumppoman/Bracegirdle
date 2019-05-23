class CreateComplaints < ActiveRecord::Migration[5.2]
  def change
    create_table :complaints do |t|
      t.references :cemetery, null: true
      t.text :summary
      t.timestamps
    end
  end
end
