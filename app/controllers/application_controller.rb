class ApplicationController < ActionController::Base
  include SessionsHelper

  Forbidden = Class.new(StandardError)

  before_action :set_pending_items

  protected

  def date_params(accepted_params, provided_params)
    date_params = {}
    accepted_params.each do |param|
      next unless provided_params.key? param
      if provided_params[param].match? %r{[0-9]{1,2}/[0-9]{1,2}/[0-9]{4}}
        date_params[param] = Date.strptime(provided_params[param], '%m/%d/%Y')
      else
        date_params[param] = Date.parse(provided_params[param]) rescue nil
      end
    end

    date_params
  end

  private

  def set_pending_items
    @pending_items = {}

    if current_user && current_user.investigator?
      @pending_items[:complaints] = current_user.complaints.count
      @pending_items[:notices] = current_user.notices.count
      @pending_items[:notifications] = current_user.notifications.count
      @pending_items[:rules] = current_user.rules.count
      @pending_items[:restoration] = current_user.restoration.count
    end
  end
end
