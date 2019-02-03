class ErrorsController < ApplicationController
  def forbidden
    @status = 403
    @message = 'You are not allowed to access this page.'
    @title = 'Forbidden'
    @breadcrumbs = false
    render :show, status: @status
  end

  def internal_server_error
    @status = 500
    @message = 'An error has occurred!'
    @title = 'Internal Server Error'
    @breadcrumbs = false
    render :show, status: @status
  end

  def show; end
end
