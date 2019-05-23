class AddClosedByToComplaints < ActiveRecord::Migration[5.2]
  def change
    add_reference :complaints, :closed_by, foreign_key: { to_table: :users }
  end
end
