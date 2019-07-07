class AddSupervisorToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :supervisor, :boolean, default: false
  end
end
