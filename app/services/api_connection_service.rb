require 'net/http'

class ApiConnectionService
  attr_reader :session

  def initialize(session)
    @session = session
  end

  def sign_in(email, password)
    res = request(:post, '/v1/users/sign_in', { login: email, password: password }, throw_on_error: false)

    if res.code.to_i == 200
      session['uid'] = res['uid']
      session['client'] = res['client']
      session['access-token'] = res['access-token']
      return true
    end

    @message = res.body

    false
  end

  def get_user(user_id)
    get("/v1/admin/users/#{user_id}")
  end

  def get_users(page_id, params)
    params.each { |_key, value| value.strip! }

    get("/v1/admin/users?page=#{page_id}&#{params.to_query}")
  end

  def get_user_posts(user_id, page_id)
    get("/v1/users/#{user_id}/posts?page=#{page_id}")
  end

  def get_posts(page_id, params)
    params.each { |_key, value| value.strip! }

    get("/v1/admin/posts?page=#{page_id}&#{params.to_query}")
  end

  def get_post(post_id)
    get("/v1/posts/#{post_id}")
  end

  def get_post_comments(post_id, page_id)
    get("/v1/posts/#{post_id}/comments?page=#{page_id}")
  end

  def get_post_likes(post_id, page_id)
    get("/v1/posts/#{post_id}/likes?page=#{page_id}")
  end

  def get_stats(date_from, date_to)
    get("/v1/admin/stats?date_from=#{date_from}&date_to=#{date_to}")
  end

  def get_flagged_posts(page_id)
    get("/v1/admin/flagged_posts?page=#{page_id}")
  end

  def get_flagged_post(post_id, page_id)
    get("/v1/admin/flagged_posts/#{post_id}/flags?page=#{page_id}")
  end

  def mark_flagged_post_as_moderated(post_id)
    put("/v1/admin/flagged_posts/#{post_id}", moderated: true)
  end

  def delete_moderated_post(post_id)
    delete("/v1/admin/flagged_posts/#{post_id}")
  end

  def get(path)
    res = request(:get, path)

    JSON.parse(res.body)
  end

  def post(path, body)
    request(:post, path, body)
  end

  def put(path, body)
    request(:put, path, body)
  end

  def delete(path)
    request(:delete, path)
  end

  # rubocop:disable all
  def request(method, path, body = nil, throw_on_error: true)
    uri = URI(File.join(session['api_server'], path))

    req = if method == :get
            Net::HTTP::Get
          elsif method == :post
            Net::HTTP::Post
          elsif method == :put
            Net::HTTP::Put
          elsif method == :delete
            Net::HTTP::Delete
          else
            raise "Unsupported method #{method}"
          end.new(uri, 'Content-Type' => 'application/json')

    set_auth_headers(req)
    req.body = body.to_json if body.present?

    res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == 'https') do |http|
      http.request(req)
    end

    if throw_on_error
      raise ApiNoAuthException, 'No auth' if res.code.to_i == 401
      raise ApiError, "#{res.uri} returned a #{res.code} error" if res.code.to_i >= 400
    end

    reset_auth_token(res)

    res
  end
  # rubocop:enable all

  def set_auth_headers(req)
    req['vreel-application-id'] = Rails.configuration.api_servers[session['api_server']]
    req['uid'] = session['uid']
    req['client'] = session['client']
    req['access-token'] = session['access-token']
  end

  def reset_auth_token(res)
    session['access-token'] = res['access-token'] if res['access-token'].present?
  end

  def get_error_message
    @message
  end
end
