class RetortModelPolicy < ApplicationPolicy
  def create?
    user.staff?
  end
  
  def index?
    show?
  end
  
  def show?
    user.staff?
  end
end