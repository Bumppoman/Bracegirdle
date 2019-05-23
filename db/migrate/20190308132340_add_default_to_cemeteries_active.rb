class AddDefaultToCemeteriesActive < ActiveRecord::Migration[5.2]
  def change
    change_column_default :cemeteries, :active, true
  end
end
