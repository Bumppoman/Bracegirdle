class RulesPolicy < ApplicationPolicy
  def create?
    user.staff?
  end

  def new?
    create?
  end
  
  def show?
    user.staff?
  end
  
  def show_for_date?
    show?
  end
end
