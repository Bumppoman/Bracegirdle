class DashboardController < ApplicationController
  skip_before_action :ensure_authenticated, only: :splash
  
  def index
    # Set complaints
    @complaints = current_user.complaints.count

    # Set notices
    @notices = current_user.notices.count

    # Set inspections
    @inspections = current_user.overdue_inspections.count

    # Set recent activity
    @recent_activity = Activity
      .includes(:user, object: [:cemetery, notable: [:cemetery]])
      .where(user: current_user)
      .order(created_at: :desc)
      .limit(3)
  end

  def search
    if params[:search] =~ /^[\d]{1,5}$/
      @cemeteries = Cemetery.where('cemid LIKE ?', "%#{params[:search]}%")
    elsif params[:search] =~ /^[\d-]{6}$/
      cemid = params[:search].split('-').join
      @cemeteries = Cemetery.where(cemid: cemid)
    else
      @cemeteries = Cemetery.where('name ILIKE ?', "%#{params[:search]}%")
    end
    
    # If there's only one result redirect to the cemetery
    if @cemeteries.length === 1
      redirect_to @cemeteries.first
    end
  end
  
  def splash
  end
end
