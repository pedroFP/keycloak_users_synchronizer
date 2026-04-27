class UserProducer
  attr_reader :payload, :key

  KAFKA_TOPIC = 'keycloak.users'.freeze

  def initialize(user)
    @payload = payload.to_h
    @key = user.keycloak_id
  end
  
  def produce
    # WIP: gem not installed nor cofigured
    Karafka.producer.produce_sync(topic: KAFKA_TOPIC, payload:, key:)
  end
end