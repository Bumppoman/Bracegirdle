class RemoveDateAcknowledgedFromComplaints < ActiveRecord::Migration[5.2]
  def change
    remove_column :complaints, :date_acknowledged
  end
end
