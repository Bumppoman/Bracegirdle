class RemoveTimestampsAndAddWarrantyToEstimates < ActiveRecord::Migration[5.2]
  def change
    remove_column :estimates, :created_at
    remove_column :estimates, :updated_at
    add_column :estimates, :warranty, :integer
  end
end
