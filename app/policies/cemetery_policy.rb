class CemeteryPolicy < ApplicationPolicy
  def create?
    user.supervisor?
  end

  def index?
    user.staff?
  end

  def index_by_county?
    index?
  end

  def index_by_region?
    index?
  end

  def new?
    create?
  end

  def options_for_county?
    show?
  end

  def overdue_inspections?
    index?
  end

  def show?
    index?
  end
end
