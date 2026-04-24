# Start services
- keycloak
- Kafka

```bash
docker compose up -d
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

