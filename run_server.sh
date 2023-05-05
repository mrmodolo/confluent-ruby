#!/bin/bash

source ~/.confluent/karafka.config

podman run -it --rm \
  -e KAFKA_CLIENT_ID=$KAFKA_CLIENT_ID \
  -e KAFKA_GROUP_ID_PREFIX=$KAFKA_GROUP_ID_PREFIX \
  -e KAFKA_BOOTSTRAP_SERVERS=$KAFKA_BOOTSTRAP_SERVERS \
  -e KAFKA_SASL_USERNAME=$KAFKA_SASL_USERNAME \
  -e KAFKA_SASL_PASSWORD=$KAFKA_SASL_PASSWORD \
  --name teste-ruby-karafka-confluent ruby-karafka-confluent bundle exec karafka s
