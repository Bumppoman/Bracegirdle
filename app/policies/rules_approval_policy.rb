class RulesApprovalPolicy < ApplicationPolicy
  def approve?
    (record.assigned_to?(user) || record.received? || record.approval_recommended?) && user.supervisor?
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
  
  def recommend_approval?
    record.assigned_to?(user)
  end
  
  def receive_revision?
    user.staff?
  end
  
  def request_revision?
    record.assigned_to?(user)
  end

  def show?
    record.assigned_to?(user) || user.supervisor?
  end
  
  def withdraw?
    record.assigned_to?(user)
  end
end
