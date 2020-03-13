class AppointmentPolicy < ApplicationPolicy
  def begin?
    record.belongs_to?(user)
  end

  def cancel?
    begin?
  end

  def create?
    user.staff?
  end

  def index?
    user.staff?
  end

  def reschedule?
    begin?
  end
end
