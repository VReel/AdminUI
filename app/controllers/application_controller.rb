class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout :layout_by_resource

  protected

  def current_user
    nil
  end

  def layout_by_resource
    if current_user.present?
      'application'
    else
      'anonymous_application'
    end
  end
end
