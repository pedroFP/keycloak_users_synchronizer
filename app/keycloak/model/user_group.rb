class Keycloak::UserGroup < Keycloak::UserGroupApi
  include ModelSerializer

  attr_accessor :id,
                :name,
                :path,
                :subGroups

  def self.init_from_params(params)
    user_group = new

    user_group.id = params['id']
    user_group.name = params['name']
    user_group.path = params['path']
    user_group.subGroups = params['subGroups']

    user_group
  end
end