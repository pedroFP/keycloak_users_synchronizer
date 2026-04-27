class Keycloak::UserGroupApi
  class << self
    def all(user_id:)
      call(user_id)
    end

    private

    def base_url(user_id)
      URI("#{Keycloak::BASE_URL}/admin/realms/#{Keycloak::REALM}/users/#{user_id}/groups")
    end

    def call(user_id)
      data = api(base_url(user_id))

      KeycloakRecordRelation.new(data.map { |attributes| init_from_params(attributes) })
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


    def init_from_params(_)
      raise "\n\nBuild `init_from_params` method in your class!\n"
    end
  end
end
