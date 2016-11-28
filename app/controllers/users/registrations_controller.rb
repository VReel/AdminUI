class Users::RegistrationsController < Devise::RegistrationsController
  protected

  # Forward to success page (where we tell them to check their email)
  def after_inactive_sign_up_path_for(_resource)
    users_unverified_account_path
  end
end
