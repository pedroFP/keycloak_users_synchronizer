# Service in charge of producing a kafka message for each Keycloak user

class SyncKeycloakUsers
  USERS_PER_PAGE = 100

  def self.call
    users_count = Keycloak::User.count
    number_of_pages = (users_count.to_f / USERS_PER_PAGE).ceil
    page = 0

    while page < number_of_pages
      Keycloak::User.page(page).limit(USERS_PER_PAGE).each do |user|
        UserProducer.new(user).produce
      end
      page += 1
    end
  end
end