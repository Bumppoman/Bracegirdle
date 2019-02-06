class DashboardController < ApplicationController
  def index
    redirect_to login_path and return unless current_user

    if current_user.supervisor?
      @complaints = Complaint.active_for(current_user).or(Complaint.pending_closure).or(Complaint.unassigned).count
    else
      @complaints = Complaint.active_for(current_user).count
    end
    @notices = NonComplianceNotice.active.where(investigator: current_user).count
    @title = 'Dashboard'
  end
end
