module Permissions
  extend ActiveSupport::Concern

  def disallow
    raise ApplicationController::Forbidden
  end

  def stipulate(permission)
    disallow unless send(permission)
  end

  private

  def must_be_employee
    current_user && !current_user.cemeterian?
  end

  def must_be_investigator
    current_user && (current_user.investigator? || current_user.supervisor?)
  end
end