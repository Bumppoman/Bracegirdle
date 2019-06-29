class ChangeLandDefaultStatusToReceived < ActiveRecord::Migration[6.0]
  def change
    change_column_default :land, :status, 1
  end
end
