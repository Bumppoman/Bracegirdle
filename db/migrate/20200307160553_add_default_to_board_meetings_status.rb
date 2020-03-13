class AddDefaultToBoardMeetingsStatus < ActiveRecord::Migration[6.0]
  def change
    change_column :board_meetings, :status, :integer, default: 1
  end
end
