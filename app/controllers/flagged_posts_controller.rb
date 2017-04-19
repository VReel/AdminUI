class FlaggedPostsController < ApplicationController
  def index

  end

  protected

  def api_data
    @api_data ||= connection.get_flagged_posts(page_id: params[:page_id])
  end

  def posts
    @posts ||= api_data['data'].map { |post_data| FlaggedPost.new(post_data) }.each { |post| post.attach_user_details(api_data['included']) }
  end
  helper_method :posts
end
