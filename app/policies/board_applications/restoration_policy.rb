class BoardApplications::RestorationPolicy < ApplicationPolicy
  def create?
    user.staff?
  end
  
  def evaluate?
    record.belongs_to? user
  end

  def index?
    user.staff?
  end

  def new?
    create?
  end

  def show?
    index?
  end
end
