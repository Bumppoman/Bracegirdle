class DashboardController < ApplicationController
  def index
    redirect_to login_path and return unless current_user

    if current_user.supervisor?
      @complaints = Complaint.pending_closure.or(Complaint.unassigned).count + @pending_items[:complaints]
    else
      @complaints = @pending_items[:complaints]
    end

    @inspections = current_user.overdue_inspections.count
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
