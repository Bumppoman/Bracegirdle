class AddDefaultToRestorationStatusAndAddIdentifierToRestoration < ActiveRecord::Migration[5.2]
  def change
    change_column :restoration, :status, :integer, default: 1
    add_column :restoration, :identifier, :string
  end
end
