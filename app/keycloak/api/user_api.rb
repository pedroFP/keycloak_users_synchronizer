class Keycloak::UserApi
  class << self
    def all
      call
    end

    def limit(number)
      url = self.url

      define_singleton_method(:url) do
        url.query = URI.encode_www_form(max: number)
        url
      end

      call
    end

    private

    def url
      URI("#{Keycloak::BASE_URL}/admin/realms/#{Keycloak::REALM}/users")
    end


    def call
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true # TODO: handle when envorionment is PRODUCTION
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request['Content-Type'] = 'application/x-www-form-urlencoded'
      request['Authorization'] = "Bearer #{Keycloak::AccessTokenGenerator.call}"

      response = http.request(request)
      data = JSON.parse(response.read_body)

      data.map { |attributes| init_from_params(attributes) }
    end

    def init_from_params
      raise "Build `init_from_params` method in your class"
    end
  end
end