class PostsController < ApplicationController
  protected

  def posts_api_data
    @posts_api_data ||= connection.get_posts(params[:page_id])
  end

  def post_api_data
    @post_api_data ||= connection.get_post(params[:id])
  end
  helper_method :post_api_data

  def comments_api_data
    comments_api_data ||= connection.get_post_comments(params[:id])
  end
  helper_method :comments_api_data

  def posts
    @posts ||= posts_api_data['data']
               .map { |post_data| Post.new(post_data) }
               .each { |post| post.attach_user_details(posts_api_data['included']) }
  end
  helper_method :posts

  def post
    @post ||= Post.new(post_api_data['data']).attach_user_details(post_api_data['included'])
  end
  helper_method :post

  def comments
    @comments ||= comments_api_data['data']
                  .map { |comment_data| Comment.new(comment_data) }
                  .each { |comment| comment.attach_user_details(comments_api_data['included']) }
  end
  helper_method :comments

  def comments_next_page_id
    comments_api_data['meta'] && comments_api_data['meta']['next_page_id']
  end
  helper_method :comments_next_page_id

  def next_page_id
    posts_api_data['meta'] && posts_api_data['meta']['next_page_id']
  end
  helper_method :next_page_id
end
