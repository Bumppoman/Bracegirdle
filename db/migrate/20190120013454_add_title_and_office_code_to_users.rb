class AddTitleAndOfficeCodeToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :title, :string
    add_column :users, :office_code, :string
  end
end
