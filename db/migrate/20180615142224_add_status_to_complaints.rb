class AddStatusToComplaints < ActiveRecord::Migration[5.2]
  def change
    add_column :complaints, :status, :integer, default: 1
  end
end
