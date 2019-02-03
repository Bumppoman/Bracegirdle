class ApplicationController < ActionController::Base
  include SessionsHelper

  Forbidden = Class.new(StandardError)
end
