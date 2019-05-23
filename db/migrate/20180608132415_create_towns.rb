class CreateTowns < ActiveRecord::Migration[5.2]
  def change
    create_table :towns do |t|
      t.integer :county
      t.string :name
    end
  end
end
