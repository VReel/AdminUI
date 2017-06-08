class PostsController < ApplicationController
  protected

  def posts_api_data
    @posts_api_data ||= connection.get_posts(
      params[:page_id],
      filter_params
    )
  end

  def post_api_data
    @post_api_data ||= connection.get_post(params[:id])
  end
  helper_method :post_api_data

  def comments_api_data
    @comments_api_data ||= connection.get_post_comments(params[:id], params[:comments_page_id])
  end
  helper_method :comments_api_data

  def likes_api_data
    @likes_api_data ||= connection.get_post_likes(params[:id], params[:likes_page_id])
  end
  helper_method :likes_api_data

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

  def likes
    @likes ||= likes_api_data['data'].map { |like_data| User.new(like_data) }
  end
  helper_method :likes

  def comments_next_page_id
    comments_api_data['meta'] && comments_api_data['meta']['next_page_id']
  end
  helper_method :comments_next_page_id

  def likes_next_page_id
    likes_api_data['meta'] && likes_api_data['meta']['next_page_id']
  end
  helper_method :likes_next_page_id

  def next_page_id
    posts_api_data['meta'] && posts_api_data['meta']['next_page_id']
  end
  helper_method :next_page_id

  def sort_options
    {
      'Created At DESC' => :created_at_desc,
      'Created At ASC' => :created_at_asc,
      'Likes DESC' => :likes_desc,
      'Likes ASC' => :likes_asc,
      'Comments DESC' => :comments_desc,
      'Comments ASC' => :comments_asc
    }
  end
  helper_method :sort_options

  def page
    Integer(params[:page_id] || 0) + 1
  end
  helper_method :page

  def count
    posts_api_data['meta']['total']
  end
  helper_method :count

  def filter_params
    params.slice(:sort, :date_from, :date_to, :user, :min_comments, :max_comments, :min_likes, :max_likes, :hash_tag)
  end
  helper_method :filter_params
end
