class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :only_confirmed

  layout :layout_by_resource

  protected

  def layout_by_resource
    if current_user.present?
      'application'
    else
      'anonymous_application'
    end
  end

  def only_confirmed
    redirect_to users_unverified_account_path if current_user && !current_user.confirmed?
  end
end
