class AddComplaintNumberToComplaints < ActiveRecord::Migration[5.2]
  def change
    add_column :complaints, :complaint_number, :string, before: :cemetery_id
  end
end
