# Get users from Keycloak
#
# @example
#   users = Keycloak::User.all
#   users = Keycloak::User.limit(10)

class Keycloak::User < Keycloak::UserApi
  include ModelSerializer

  attr_accessor :groups,
                :first_name,
                :last_name,
                :email,
                :keycloak_id,
                :user_enabled_status,
                :ad_id,
                :ad_dn,
                :ad_cn,
                :ad_department,
                :ad_title,
                :ad_office,
                :ad_telephonenumber,
                :ad_homephone,
                :ad_mobile,
                :ad_fax,
                :ad_streetaddress,
                :employee_number,
                :company,
                :parent,
                :keycloak_ad_id,
                :keycloak_ad_dn

  def self.init_from_params(params)
    user = new

    # user.groups = group_info(params) # TODO: handle user groups
    user.first_name = params['firstName']
    user.last_name = params['lastName']
    user.email = params['email']
    user.keycloak_id = params['id']
    user.user_enabled_status = params['enabled']

    unless params['attributes'].nil?
      attributes = params['attributes']
      user.ad_id = attributes['LDAP_ID']&.first
      user.ad_dn = attributes['LDAP_ENTRY_DN']&.first
      user.ad_cn = attributes['ad_cn']&.first
      user.ad_department = attributes['department']&.first
      user.ad_title = attributes['title']&.first
      user.ad_office = attributes['office']&.first
      user.ad_telephonenumber = attributes['ad_telephonenumber']&.first
      user.ad_homephone = attributes['ad_homephone']&.first
      user.ad_mobile = attributes['ad_mobile']&.first
      user.ad_fax = attributes['ad_fax']&.first
      user.ad_streetaddress = attributes['ad_streetaddress']&.first

      employee_id = attributes['employee_id']&.first&.empty? ? nil : attributes['employee_id']&.first
      employee_number = attributes['employee_number']&.first&.empty? ? nil : attributes['employee_number']&.first
      user.employee_number = employee_id || employee_number

      user.company = attributes['company']&.first
      user.parent = attributes['manager']&.first

      # These fields are not in the user model and only exists for the users created directly in keycloak
      user.keycloak_ad_id = attributes['ad_id']&.first
      user.keycloak_ad_dn = attributes['ad_dn']&.first
    end

    user
  end
end

