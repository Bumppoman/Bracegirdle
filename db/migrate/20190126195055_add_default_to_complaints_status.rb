class AddDefaultToComplaintsStatus < ActiveRecord::Migration[5.2]
  def change
    change_column :complaints, :status, :integer, default: 1
  end
end
