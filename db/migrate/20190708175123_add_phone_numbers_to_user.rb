class AddPhoneNumbersToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :office_phone, :string
    add_column :users, :cell_phone, :string
  end
end
