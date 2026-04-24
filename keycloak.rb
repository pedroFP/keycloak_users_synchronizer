require 'uri'
require 'json'
require 'net/http'
require 'openssl'
require 'dotenv/load'

module Keycloak
  BASE_URL = ENV.fetch('KEYCLOAK_BASE_URL', 'http://localhost:8080').freeze
  REALM = ENV.fetch('KEYCLOAK_REALM').freeze
end

Dir[File.join(__dir__, 'app', '**', '*.rb')].each { |f| require_relative f }
