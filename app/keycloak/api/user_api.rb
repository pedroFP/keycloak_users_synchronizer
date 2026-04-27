class Keycloak::UserApi
  class << self
    def all
      call
    end

    def limit(number)
      url = self.url
      url_params = URI.decode_www_form(url.query || "") + { max: number }.to_a

      define_singleton_method(:base_url) do
        url.query = URI.encode_www_form(url_params)
        url
      end

      call
    end

    def where(params)
      # INFO: refer to the docs to see which arguments are available 
      # https://www.keycloak.org/docs-api/latest/rest-api/index.html#_query_parameters_72

      url = self.url
      url_params = URI.decode_www_form(url.query || "") + params.to_a

      define_singleton_method(:base_url) do
        url.query = URI.encode_www_form(url_params)
        url
      end

      self
    end


    def page(offset)
      # INFO: `first` is the Pagination offset
      # https://www.keycloak.org/docs-api/latest/rest-api/index.html#_query_parameters_72

      url = self.url
      url_params = URI.decode_www_form(url.query || "") + { first: offset }.to_a

      define_singleton_method(:base_url) do
        url.query = URI.encode_www_form(url_params)
        url
      end

      self
    end

    def count
      api URI("#{Keycloak::BASE_URL}/admin/realms/#{Keycloak::REALM}/users/count")
    end

    private

    def call
      data = api(base_url)

      reset_url!

      KeycloakRecordRelation.new(data.map { |attributes| init_from_params(attributes) })
    end

    def base_url
      URI("#{Keycloak::BASE_URL}/admin/realms/#{Keycloak::REALM}/users")
    end

    def api(url)
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      request = Net::HTTP::Get.new(url)
      request['Content-Type'] = 'application/x-www-form-urlencoded'
      request['Authorization'] = "Bearer #{Keycloak::AccessTokenGenerator.call}"

      response = http.request(request)
      JSON.parse(response.read_body)
    end

    def reset_url!
      define_singleton_method(:base_url) do
        URI("#{Keycloak::BASE_URL}/admin/realms/#{Keycloak::REALM}/users")
      end
    end

    def init_from_params
      raise "Build `init_from_params` method in your class"
    end
  end
end