class CemeteryInspectionPolicy < ApplicationPolicy
  def complete?
    save?
  end
  
  def create?
    user.staff?
  end

  def finalize?
    record.belongs_to? user
  end

  def incomplete?
    user.investigator?
  end

  def perform?
    user.investigator?
  end

  def revise?
    finalize?
  end
  
  def save?
    record.belongs_to? user
  end

  def show?
    user.staff?
  end

  def upload?
    create?
  end

  def view_full_package?
    show?
  end

  def view_report?
    show?
  end
end
