class AddUpdatedAtToTrustees < ActiveRecord::Migration[6.0]
  def change
    add_column :trustees, :updated_at, :datetime, null: false, default: Time.zone.now
    change_column_default :trustees, :updated_at, nil
  end
end
