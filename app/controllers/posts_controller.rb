class PostsController < ApplicationController
  protected

  def posts_api_data
    @posts_api_data ||= connection.get_posts(params[:page_id])
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
end
