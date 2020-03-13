class CreateBoardMeetings < ActiveRecord::Migration[6.0]
  def change
    create_table :board_meetings do |t|
      t.datetime :date
      t.string :location
    end
  end
end
