class BoardMeetingPolicy < ApplicationPolicy
  def download_agenda?
    show?
  end

  def finalize_agenda?
    user.supervisor?
  end
  
  def index?
    user.staff?
  end

  def show?
    index?
  end
end
