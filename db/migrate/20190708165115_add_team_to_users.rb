class AddTeamToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :team, :integer
  end
end
