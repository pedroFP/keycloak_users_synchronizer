# Start services
- Keycloak
- Kafka
- keycloak-users-synchronizer

```bash
docker compose up -d
```

# Start Karafka Server
```bash
bin/dev
```

# Keycloack service

Sign in to `master` realm

```bash
curl -X POST http://localhost:8080/realms/master/protocol/openid-connect/token \
-H "Content-Type: application/x-www-form-urlencoded" \
-d "client_id=admin-cli" \
-d "username=admin" \
-d "password=admin" \
-d "grant_type=password"

# $TOKEN=${your-token-from-the-response}
```

Get users from a realm

```bash
curl -H "Authorization: Bearer $TOKEN" \
http://localhost:8080/admin/realms/myrealm/users
```

# Test in Console

```bash
⢀⡴⠊⢉⡟⢿ 
⣎⣀⣴⡋⡟⣻ 
⣟⣼⣱⣽⣟⣾ 

$ bin/console
```

```ruby
# i.e get users

users = Keycloak::User.limit(10)

user = users.first

user_id = user.keycloak_id
Keycloak::UserGroup.all(user_id: user_id)

```

# Trigger sync through Karafka

```ruby
Karafka.producer.produce_sync(topic: 'keycloak.users_sync', payload: {}.to_json, key: 'sync-users-key')
# │
# └── Will trigger service to sync users from Keycloak => SyncKeycloakUsers.call
```

