class CreateTrustees < ActiveRecord::Migration[5.2]
  def change
    create_table :trustees do |t|
      t.references :person, foreign_key: true
      t.references :cemetery, foreign_key: true
      t.integer :position
    end
  end
end
