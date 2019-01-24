class ChangeComplaintsTypeToStringForArray < ActiveRecord::Migration[5.2]
  def change
    change_column :complaints, :type, :string
  end
end
