class RenameRestorationTypeToApplicationType < ActiveRecord::Migration[5.2]
  def change
    rename_column :restoration, :type, :application_type
  end
end
