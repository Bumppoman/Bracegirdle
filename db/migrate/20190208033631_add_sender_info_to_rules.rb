class AddSenderInfoToRules < ActiveRecord::Migration[5.2]
  def change
    change_table :rules do |t|
      t.string :sender, after: :submission_date
      t.string :sender_email
      t.string :sender_street_address
      t.string :sender_city
      t.string :sender_state
      t.string :sender_zip
    end
  end
end
