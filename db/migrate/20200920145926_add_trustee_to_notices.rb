class AddTrusteeToNotices < ActiveRecord::Migration[6.0]
  def change
    add_reference :notices, :trustee, index: true
    add_foreign_key :notices, :trustees
  end
end
