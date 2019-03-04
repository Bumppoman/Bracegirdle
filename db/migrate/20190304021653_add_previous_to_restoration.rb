class AddPreviousToRestoration < ActiveRecord::Migration[5.2]
  def change
    add_column :restoration, :previous_exists, :boolean, default: false
    add_column :restoration, :previous_type, :integer
    add_column :restoration, :previous_date, :string
  end
end
