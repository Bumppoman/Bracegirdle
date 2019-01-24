class RenameComplaintsType < ActiveRecord::Migration[5.2]
  def change
    rename_column :complaints, :type, :complaint_type
  end
end
