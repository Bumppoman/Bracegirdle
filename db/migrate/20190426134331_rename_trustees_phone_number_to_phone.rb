class RenameTrusteesPhoneNumberToPhone < ActiveRecord::Migration[5.2]
  def change
    rename_column :trustees, :phone_number, :phone
  end
end
