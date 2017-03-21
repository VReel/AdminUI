require 'net/http'

class ApiConnectionService
  attr_reader :session

  def initialize(session)
    @session = session
  end

  def sign_in(email, password)
    res = post('/v1/users/sign_in', { login: email, password: password } )

    if res.code.to_i == 200
      session['uid'] = res['uid']
      session['client'] = res['client']
      session['access-token'] = res['access-token']
      return true
    end

    @message = res.body

    false
  end

  def get_stats(date_from, date_to)
    res = get("/v1/stats?date_from=#{date_from}&date_to=#{date_to}" )
  end

  def get(path)
    uri = URI(File.join(session['api_server'], path))

    req = Net::HTTP::Get.new(uri)
    set_auth_headers(req)

    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    session['access-token'] = res['access-token']

    JSON.parse(res.body)
  end

  def post(path, body)
    uri = URI(File.join(session['api_server'], path))

    req = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    puts 'HELLO'
    set_auth_headers(req)
    req.body = body.to_json
    res = Net::HTTP.start(uri.hostname, uri.port, :use_ssl => uri.scheme == 'https') do |http|
      http.request(req)
    end

    res
  end

  def set_auth_headers(req)
    req['vreel-application-id'] = Rails.configuration.api_servers[session['api_server']]

    puts session['api_server']
    puts 'using ' + Rails.configuration.api_servers[session['api_server']]

    req['uid'] = session['uid'] if session['uid'].present?
    req['client'] = session['client'] if session['client'].present?
    req['access-token'] = session['access-token'] if session['access-token'].present?
  end

  def get_error_message
    @message
  end
end
