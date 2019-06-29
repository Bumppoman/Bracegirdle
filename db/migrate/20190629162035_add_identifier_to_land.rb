class AddIdentifierToLand < ActiveRecord::Migration[6.0]
  def change
    add_column :land, :identifier, :string, before: :status
  end
end
