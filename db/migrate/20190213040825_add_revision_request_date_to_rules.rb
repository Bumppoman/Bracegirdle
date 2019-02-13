class AddRevisionRequestDateToRules < ActiveRecord::Migration[5.2]
  def change
    add_column :rules, :revision_request_date, :date
  end
end
