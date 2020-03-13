class AddApplicationToMatter < ActiveRecord::Migration[6.0]
  def change
    add_column :matters, :application_type, :string
    add_column :matters, :application_id, :integer
  end
end
