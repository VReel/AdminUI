class FlaggedPostsController < ApplicationController
  def update
    return delete_post if params[:commit] == 'Delete'

    mark_post_moderated
  end

  protected

  def delete_post
    res = connection.delete_moderated_post(params[:id])

    if res.is_a? Net::HTTPSuccess
      flash[:notice] = "Post #{params[:id]} deleted"
      return redirect_to flagged_posts_path
    end

    handle_failed_request(res)
  end

  def mark_post_moderated
    res = connection.mark_flagged_post_as_moderated(params[:id])

    if res.is_a? Net::HTTPSuccess
      flash[:notice] = "Post #{params[:id]} marked as moderated"
      return redirect_to flagged_posts_path
    end

    handle_failed_request(res)
  end

  def handle_failed_request(res)
    flash[:alert] = "Something went wrong: #{res.body.first(200)}"

    redirect_to flagged_post_path(params[:id])
  end

  # List of flagged posts.
  def posts_api_data
    @posts_api_data ||= connection.get_flagged_posts(params[:page_id])
  end

  # Single flagged post and it's flags.
  def flagged_post_api_data
    @flagged_post_api_data ||= connection.get_flagged_post(params[:id], params[:page_id])
  end

  def posts
    @posts ||= posts_api_data['data']
               .map { |post_data| FlaggedPost.new(post_data) }
               .each { |post| post.attach_user_details(posts_api_data['included']) }
  end
  helper_method :posts

  def flagged_post
    @flagged_post ||= FlaggedPost
                      .new(flagged_post_api_data['included'].detect { |item| item['id'] == params[:id] })
                      .attach_flag_details(flagged_post_api_data)
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
