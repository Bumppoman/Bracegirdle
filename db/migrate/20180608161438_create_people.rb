class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.string :name
      t.string :address
      t.string :phone_number
      t.string :email
      t.float :latitude
      t.float :longitude
    end
  end
end
