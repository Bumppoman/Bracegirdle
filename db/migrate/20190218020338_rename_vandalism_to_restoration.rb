class RenameVandalismToRestoration < ActiveRecord::Migration[5.2]
  def change
    rename_table :vandalism, :restoration
  end
end
