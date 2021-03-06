class ComplaintPolicy < ApplicationPolicy
  def all?
    index?
  end

  def assign?
    user.supervisor?
  end

  def begin_investigation?
    record.received? && (record.belongs_to?(user) || user.supervisor?)
  end

  def close?
    record.belongs_to?(user) || user.supervisor?
  end

  def complete_investigation?
    record.belongs_to?(user)
  end

  def create?
    user.staff?
  end

  def index?
    user.staff?
  end

  def index_by_user?
    index?
  end

  def new?
    create?
  end
  
  def reassign?
    record.belongs_to?(user) || user.supervisor?
  end

  def reopen_investigation?
    user.supervisor?
  end
  
  def recommend_closure?
    record.belongs_to?(user)
  end

  def request_update?
    user.supervisor?
  end

  def show?
    index?
  end
end
