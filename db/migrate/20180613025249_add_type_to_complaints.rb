class AddTypeToComplaints < ActiveRecord::Migration[5.2]
  def change
    add_column :complaints, :type, :integer
  end
end
