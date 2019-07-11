class DashboardController < ApplicationController
  def index
    # Set complaints
    @complaints = current_user.complaints.count
    @complaints += Complaint.pending_closure.or(Complaint.unassigned).count if current_user.supervisor?

    # Set notices
    @notices = current_user.notices.count

    # Set inspections
    @inspections = current_user.overdue_inspections.count

    # Set recent activity
    @recent_activity = Activity.includes(:user, :object).where(user: current_user).order(created_at: :desc).limit(3)
  end

  def search
    if params[:search] =~ /^[\d-]{1,6}$/
      /(?<county>\d{2})-?(?<id>\d+)/ =~ params[:search]
      @cemeteries = Cemetery.where(county: county.to_i, order_id: id.to_i)
    else
      @cemeteries = Cemetery.where(Cemetery.arel_table[:name].matches("%#{params[:search]}%")).order(:county, :order_id)
    end
  end
end
