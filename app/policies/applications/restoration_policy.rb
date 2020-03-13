class Applications::RestorationPolicy < ApplicationPolicy
  def create?
    user.staff?
  end

  def index?
    user.staff?
  end

  def new?
    create?
  end

  def process_restoration?
    record.belongs_to? user
  end

  def show?
    index?
  end
end
