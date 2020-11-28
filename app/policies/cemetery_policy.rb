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
  
  def index_with_overdue_inspections?
    index?
  end

  def new?
    create?
  end

  def show?
    index?
  end
end
