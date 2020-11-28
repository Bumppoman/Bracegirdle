class CrematoryPolicy < ApplicationPolicy
  def create?
    user.staff?
  end
  
  def index?
    show?
  end
  
  def new?
    create?
  end
  
  def show?
    user.staff?
  end
end