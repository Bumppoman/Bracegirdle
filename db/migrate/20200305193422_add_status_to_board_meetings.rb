class AddStatusToBoardMeetings < ActiveRecord::Migration[6.0]
  def change
    add_column :board_meetings, :status, :integer
  end
end
