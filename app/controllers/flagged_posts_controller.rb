class FlaggedPostsController < ApplicationController
  protected

  def api_data
    @api_data ||= connection.get_flagged_posts(params[:page_id])
  end

  def posts
    @posts ||= api_data['data'].map { |post_data| FlaggedPost.new(post_data) }.each { |post| post.attach_user_details(api_data['included']) }
  end
  helper_method :posts

  def next_page_id
    api_data['meta'] && api_data['meta']['next_page_id']
  end
  helper_method :next_page_id
end
