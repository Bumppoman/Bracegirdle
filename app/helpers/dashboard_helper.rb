module DashboardHelper
  def investigator_board_applications
    if current_user.supervisor?
      @pending_items[:restoration] + Restoration.pending_supervisor_review.count
    else
      @pending_items[:restoration]
    end
  end
end
