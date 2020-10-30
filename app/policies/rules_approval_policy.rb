class RulesApprovalPolicy < ApplicationPolicy
  def approve?
    record.assigned_to?(user) || (record.received? && user.supervisor?)
  end

  def assign?
    user.supervisor?
  end

  def create?
    user.staff?
  end

  def download_approval_letter?
    user.staff?
  end

  def index?
    user.investigator?
  end

  def new?
    create?
  end
  
  def receive_revision?
    create?
  end

  def show?
    record.assigned_to?(user) || user.supervisor?
  end
end
