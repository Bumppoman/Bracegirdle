module Permissions
  extend ActiveSupport::Concern

  def disallow
    ensure_authenticated
    raise ApplicationController::Forbidden
  end

  def ensure_authenticated
    redirect_to :login and return unless current_user
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

  def must_be_supervisor
    current_user && current_user.supervisor?
  end
end
