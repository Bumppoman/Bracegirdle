class ContractorPolicy < ApplicationPolicy
  def edit?
    user.staff?
  end
  
  def update?
    edit?
  end
end