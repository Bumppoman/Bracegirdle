class NoticePolicy < ApplicationPolicy
  def create?
    user.staff?
  end

  def download?
    show?
  end

  def follow_up?
    resolve?
  end

  def index?
    user.staff?
  end

  def new?
    create?
  end

  def resolve?
    record.belongs_to? user
  end

  def receive_response?
    resolve?
  end

  def show?
    index?
  end
end
