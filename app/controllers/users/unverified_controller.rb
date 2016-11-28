class Users::UnverifiedController < ApplicationController
  skip_before_action :only_confirmed

  def resend_confirmation
    current_user.send_confirmation_instructions

    flash.notice = 'Confirmation instructions resent'

    redirect_to users_unverified_account_path
  end
end
