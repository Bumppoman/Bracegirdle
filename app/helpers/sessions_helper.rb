module SessionsHelper
  def current_user
    if session[:user_id]
      @current_user ||= User.find(session[:user_id])
    else
      @current_user = nil
    end
  end

  def get_token
    url = URI("https://#{Rails.application.credentials.auth0[:domain]}/oauth/token")

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request['content-type'] = 'application/x-www-form-urlencoded'
    request.body = "grant_type=client_credentials&client_id=#{Rails.application.credentials.auth0[:client_id]}&client_secret=#{Rails.application.credentials.auth0[:client_secret]}&audience=https%3A%2F%2Fbracegirdle.auth0.com%2Fapi%2Fv2%2F"

    response = http.request(request)
    JSON.parse(response.read_body)
  end
end
