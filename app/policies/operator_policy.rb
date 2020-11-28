class OperatorPolicy < ApplicationPolicy
  def create?
    user.staff?
  end
  
  def show?
    user.staff?
  end
  
  def update?
    user.staff?
  end
end