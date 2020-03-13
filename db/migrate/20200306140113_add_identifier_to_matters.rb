class AddIdentifierToMatters < ActiveRecord::Migration[6.0]
  def change
    add_column :matters, :identifier, :string
  end
end
