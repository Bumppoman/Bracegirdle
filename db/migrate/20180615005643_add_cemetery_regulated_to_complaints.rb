class AddCemeteryRegulatedToComplaints < ActiveRecord::Migration[5.2]
  def change
    add_column :complaints, :cemetery_regulated, :boolean, after: :type, default: true
  end
end
