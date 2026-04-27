# frozen_string_literal: true

# Example consumer that prints messages payloads
class RequestUsersSyncConsumer < ApplicationConsumer
  def consume
    messages.each { |_message| SyncKeycloakUsers.call }
  end
end
