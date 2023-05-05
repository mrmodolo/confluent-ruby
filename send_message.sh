#!/bin/bash

source ~/.confluent/karafka.config

podman run -it --rm \
  -e KAFKA_BOOTSTRAP_SERVERS=$KAFKA_BOOTSTRAP_SERVERS \
  -e KAFKA_SASL_USERNAME=$KAFKA_SASL_USERNAME \
  -e KAFKA_SASL_PASSWORD=$KAFKA_SASL_PASSWORD \
  --name send-ruby-karafka-confluent ruby-karafka-confluent bash -c "echo \"Karafka.producer.produce_sync(topic: 'partnerNotifications_baas_v0', payload: { 'ping' => 'pong' }.to_json)\" | bundle exec karafka c"
