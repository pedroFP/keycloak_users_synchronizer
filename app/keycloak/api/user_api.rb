module Keycloak
  class UserApi
    class << self
      def url
        URI("#{Keycloak::BASE_URL}/admin/realms/#{Keycloak::REALM}/users")
      end

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

      def call
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = false # TODO: handle when envorionment is PRODUCTION
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Get.new(url)
        request['Content-Type'] = 'application/x-www-form-urlencoded'
        request['Authorization'] = "Bearer #{Keycloak::AccessTokenGenerator.call}"

        response = http.request(request)
        data = JSON.parse(response.read_body)

        puts data.to_json

        data.map { |user_attributes| init_user_from_params(user_attributes) }
      end

      def init_user_from_params(user_attributes)
        user = User.new
        # user.groups = group_info(user_attributes)
        user.first_name = user_attributes['firstName']
        user.last_name = user_attributes['lastName']
        user.email = user_attributes['email']
        user.keycloak_id = user_attributes['id']
        user.user_enabled_status = user_attributes['enabled']

        unless user_attributes['attributes'].nil?
          user.ad_id = user_attributes['attributes']['LDAP_ID']&.first
          user.ad_dn = user_attributes['attributes']['LDAP_ENTRY_DN']&.first
          user.ad_cn = user_attributes['attributes']['ad_cn']&.first
          user.ad_department = user_attributes['attributes']['department']&.first
          user.ad_title = user_attributes['attributes']['title']&.first
          user.ad_office = user_attributes['attributes']['office']&.first
          user.ad_telephonenumber = user_attributes['attributes']['ad_telephonenumber']&.first
          user.ad_homephone = user_attributes['attributes']['ad_homephone']&.first
          user.ad_mobile = user_attributes['attributes']['ad_mobile']&.first
          user.ad_fax = user_attributes['attributes']['ad_fax']&.first
          user.ad_streetaddress = user_attributes['attributes']['ad_streetaddress']&.first
          user.employee_number = user_attributes['attributes']['employee_id']&.first&.presence || user_attributes['attributes']['employee_number']&.first&.presence
          user.company = user_attributes['attributes']['company']&.first
          user.parent = user_attributes['attributes']['manager']&.first

          # These fields are not in the user model and only exists for the users created directly in keycloak
          user.keycloak_ad_id = user_attributes['attributes']['ad_id']&.first
          user.keycloak_ad_dn = user_attributes['attributes']['ad_dn']&.first
        end

        user
      end
    end
  end
end