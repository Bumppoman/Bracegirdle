class AddRequestMethodToRules < ActiveRecord::Migration[5.2]
  def change
    add_column :rules, :request_by_email, :boolean, after: :sender
  end
end
