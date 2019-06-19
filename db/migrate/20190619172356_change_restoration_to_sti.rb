class ChangeRestorationToSti < ActiveRecord::Migration[6.0]
  def change
    rename_column :restoration, :application_type, :type
    change_column :restoration, :type, :string
  end
end
