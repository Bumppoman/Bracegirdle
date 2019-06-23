class CreateAppointments < ActiveRecord::Migration[6.0]
  def change
    create_table :appointments do |t|
      t.references :user
      t.references :cemetery
      t.datetime :begin
      t.datetime :end
      t.text :notes
    end
  end
end
