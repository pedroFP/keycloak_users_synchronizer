# Manages Keycloak access token generation to request API endpoints
#
# @example
#   token = Keycloak::AccessTokenGenerator.call

class Keycloak::AccessTokenGenerator
  def self.call
    # TODO: store token in cache
    new.access_token
  end

  def access_token
    @access_token ||= generate_access_token
  end

  private

  def generate_access_token
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true # TODO: handle when envorionment is PRODUCTION
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new(url)
    request['Content-Type'] = 'application/x-www-form-urlencoded'
    request.body = URI.encode_www_form(body)

    response = http.request(request)
    return false unless response.code == '200'

    JSON.parse(response.read_body)['access_token']
  end

  def body
    # {
    #   client_id: ENV.fetch('KEYCLOAK_CLIENT_ID', 'admin-cli'),
    #   username: ENV.fetch('KEYCLOAK_ADMIN_USERNAME'),
    #   password: ENV.fetch('KEYCLOAK_ADMIN_PASSWORD'),
    #   grant_type: 'password'
    # }

    {
      client_secret: ENV.fetch('KEYCLOAK_CLIENT_SECRET'),
      client_id: ENV.fetch('KEYCLOAK_CLIENT_ID', 'admin-cli'),
      grant_type: 'client_credentials'
    }
  end

  def url
    base  = ENV.fetch('KEYCLOAK_BASE_URL')
    realm = ENV.fetch('KEYCLOAK_REALM')

    @url ||= URI("#{base}/realms/#{realm}/protocol/openid-connect/token")
  end
end
