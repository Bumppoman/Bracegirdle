class ContractorPolicy < ApplicationPolicy
  def create?
    user.staff?
  end
  
  def index?
    show?
  end
  
  def show?
    user.staff?
  end
  
  def update?
    user.staff?
  end
end