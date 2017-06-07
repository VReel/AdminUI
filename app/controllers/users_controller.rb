class UsersController < ApplicationController
  protected

  def users_api_data
    @users_api_data ||= connection.get_users(params[:page_id])
  end

  def user_api_data
    @user_api_data ||= connection.get_user(params[:id])
  end
  helper_method :user_api_data

  def user
    @user ||= User.new(user_api_data['data'])
  end
  helper_method :user
end
