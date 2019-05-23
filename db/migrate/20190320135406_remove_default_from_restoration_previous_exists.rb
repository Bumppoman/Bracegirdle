class RemoveDefaultFromRestorationPreviousExists < ActiveRecord::Migration[5.2]
  def change
    change_column_default :restoration, :previous_exists, nil
  end
end
