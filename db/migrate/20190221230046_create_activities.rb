class CreateActivities < ActiveRecord::Migration[5.2]
  def change
    create_table :activities do |t|
      t.references :user
      t.string :model_type
      t.integer :model_id
      t.string :activity_performed
      t.timestamps
    end
  end
end
