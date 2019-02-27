module DashboardHelper
  def investigator_board_applications
    @pending_items[:restoration]
  end

  def investigator_investigations
    @pending_items[:complaints] + @pending_items[:notices]
  end
end
