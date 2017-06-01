class ApiNoAuthException < StandardError
end

class ApplicationController < ActionController::Base
  rescue_from ApiNoAuthException, with: :no_auth
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :redirect_anonymous

  layout :layout_by_resource

  protected

  def current_user_present?
    session['uid'].present?
  end

  def layout_by_resource
    if current_user_present?
      'application'
    else
      'anonymous_application'
    end
  end

  def redirect_anonymous
    return if current_user_present?
    return if request.path == new_session_path

    redirect_to new_session_path
  end

  def connection
    @connection ||= ApiConnectionService.new(session)
  end

  def no_auth
    session['uid'] = nil
    flash[:notice] = 'You have been logged out by the API'
    return redirect_to '/'
  end
end
