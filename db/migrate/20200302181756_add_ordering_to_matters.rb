class AddOrderingToMatters < ActiveRecord::Migration[6.0]
  def change
    add_column :matters, :order, :integer
    add_column :board_meetings, :initial_index, :integer
  end
end
