class UsersController < ApplicationController
  protected

  def users_api_data
    @users_api_data ||= connection.get_users(params[:page_id], filter_params)
  end

  def user_api_data
    @user_api_data ||= connection.get_user(params[:id])
  end
  helper_method :user_api_data

  def user
    @user ||= User.new(user_api_data['data'])
  end
  helper_method :user

  def users
    @users ||= users_api_data['data'].map { |user_data| User.new(user_data) }
  end
  helper_method :users

  def next_page_id
    users_api_data['meta'] && users_api_data['meta']['next_page_id']
  end
  helper_method :next_page_id

  def sort_options
    {
      'Created At DESC' => :created_at_desc,
      'Created At ASC' => :created_at_asc,
      'Confirmed At DESC' => :confirmed_at_desc,
      'Confirmed At ASC' => :confirmed_at_asc,
      'Posts DESC' => :posts_desc,
      'Posts ASC' => :posts_asc,
      'Followers DESC' => :followers_desc,
      'Followers ASC' => :followers_asc,
      'Following DESC' => :following_desc,
      'Following ASC' => :following_asc
    }
  end
  helper_method :sort_options

  def confirmed_options
    {
      'Any' => nil,
      'Only confirmed' => true,
      'Only unconfirmed' => false
    }
  end
  helper_method :confirmed_options

  def page
    Integer(params[:page_id] || 0) + 1
  end
  helper_method :page

  def count
    users_api_data['meta']['total']
  end
  helper_method :count

  def filter_params
    params.slice :sort, :handle, :date_from, :date_to, :min_posts, :max_posts, :min_followers,
                 :max_followers, :min_following, :max_following, :follows_user, :following_user,
                 :confirmed
  end
  helper_method :filter_params
end
