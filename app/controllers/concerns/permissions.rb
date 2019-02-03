module Permissions
  extend ActiveSupport::Concern

  PERMISSIONS = {
      must_be_investigator: 2,
      must_be_supervisor: 3
  }.freeze

  def able_to?(permission)
    current_user && current_user.role >= PERMISSIONS[permission]
  end

  def disallow
    raise ApplicationController::Forbidden
  end

  def stipulate(permission)
    disallow unless able_to? permission
  end

  def self.included(base)
    base.helper_method :able_to?
  end
end