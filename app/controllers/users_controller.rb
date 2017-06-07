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

  def posts_api_data
    @posts_api_data ||= connection.get_user_posts(params[:id], params[:page_id])
  end

  def posts
    @posts ||= posts_api_data['data']
               .map { |post_data| Post.new(post_data) }
               .each { |post| post.attach_user_details(posts_api_data['included']) }
  end
  helper_method :posts

  def next_page_id
    posts_api_data['meta'] && posts_api_data['meta']['next_page_id']
  end
  helper_method :next_page_id

  def page
    Integer(params[:page_id] || 0) + 1
  end
  helper_method :page
end
