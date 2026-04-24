# Get users from Keycloak
#
# @example
#   users = Keycloak::User.all
#   users = Keycloak::User.limit(10)

class Keycloak::User < Keycloak::UserApi
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
end

