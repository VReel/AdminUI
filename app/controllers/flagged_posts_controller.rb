class FlaggedPostsController < ApplicationController
  def update
    if params['commit'] == 'Delete'
      res = connection.delete_moderated_post(params[:id])
      message = "Post #{params[:id]} deleted"
    else
      res = connection.mark_flagged_post_as_moderated(params[:id])
      message = "Post #{params[:id]} marked as moderated"
    end

    if res.code.to_i == 200
      flash[:notice] = message
      return redirect_to flagged_posts_path
    else
      flash[:alert] = "Something went wrong: #{res.body.first(200)}"
      return redirect_to flagged_post_path(params[:id])
    end
  end

  protected

  def posts_api_data
    @posts_api_data ||= connection.get_flagged_posts(params[:page_id])
  end

  def flagged_post_api_data
    @flagged_post_api_data ||= connection.get_flagged_post(params[:id], params[:page_id])
  end

  def posts
    @posts ||= posts_api_data['data'].map { |post_data| FlaggedPost.new(post_data) }.each { |post| post.attach_user_details(posts_api_data['included']) }
  end
  helper_method :posts

  def flagged_post
    @flagged_post ||= FlaggedPost.
                        new(flagged_post_api_data['included'].detect { |item| item['id'] == params[:id] }).
                        attach_flag_details(flagged_post_api_data).
                        attach_user_details(flagged_post_api_data['included'])
  end
  helper_method :flagged_post

  def next_page_id
    posts_api_data['meta'] && posts_api_data['meta']['next_page_id']
  end
  helper_method :next_page_id

  def flags_next_page_id
    flagged_post_api_data['meta'] && flagged_post_api_data['meta']['next_page_id']
  end
  helper_method :flags_next_page_id
end
