class CreateMatters < ActiveRecord::Migration[6.0]
  def change
    create_table :matters do |t|
      t.references :board_meeting
      t.integer :status, default: 1
      t.text :comments
    end
  end
end
