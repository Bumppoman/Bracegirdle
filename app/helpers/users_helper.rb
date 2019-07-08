module UsersHelper
  def team_board_applications(team)
    Restoration.team(team).count
  end
end
