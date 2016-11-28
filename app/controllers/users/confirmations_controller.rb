class Users::ConfirmationsController < Devise::ConfirmationsController
  skip_before_action :only_confirmed, only: :show

  def show
    return redirect_to '/' if already_confirmed_current_user?
    super do |resource|
      unless current_user.present? && current_user == resource
        sign_out
        flash.notice = 'Your email address has been verified' if resource.errors.empty?
        return redirect_to new_user_session_path
      end
    end
  end

  private

  def already_confirmed_current_user?
    current_user.present? && current_user.confirmed? && current_user.confirmation_token == params[:confirmation_token]
  end
end
