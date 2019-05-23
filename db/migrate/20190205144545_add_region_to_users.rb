class AddRegionToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :region, :integer, before: :office_code
  end
end
