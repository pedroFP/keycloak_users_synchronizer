require 'uri'
require 'json'
require 'net/http'
require 'openssl'
require 'dotenv/load'

# Namespace for Keycloak HTTP client classes.
class Keycloak; end

require_relative 'keycloak/access_token_generator'
require_relative 'keycloak/realm'
