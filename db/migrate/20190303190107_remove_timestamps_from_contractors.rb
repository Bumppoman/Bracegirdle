class RemoveTimestampsFromContractors < ActiveRecord::Migration[5.2]
  def change
    remove_column :contractors, :created_at
    remove_column :contractors, :updated_at
  end
end
