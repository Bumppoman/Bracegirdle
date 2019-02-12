class ApplicationController < ActionController::Base
  include SessionsHelper

  Forbidden = Class.new(StandardError)

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
end
