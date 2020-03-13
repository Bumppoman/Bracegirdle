class RulesPolicy < ApplicationPolicy
  def approve?
    record.assigned_to?(user) || (record.received? && user.supervisor?)
  end

  def assign?
    user.supervisor?
  end

  def create?
    user.staff?
  end

  def create_old_rules?
    create?
  end

  def download_approval?
    show?
  end

  def index?
    user.investigator?
  end

  def new?
    create?
  end

  def request_revision?
    approve?
  end

  def review?
    record.assigned_to?(user) || user.supervisor?
  end

  def show?
    user.staff?
  end

  def upload_old_rules?
    create?
  end

  def upload_revision?
    create?
  end
end
