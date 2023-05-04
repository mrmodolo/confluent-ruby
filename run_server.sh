#!/bin/bash

source ./.config

podman run -it --rm \
  -e KAFKA_BOOTSTRAP_SERVERS=$KAFKA_BOOTSTRAP_SERVERS \
  -e KAFKA_SASL_USERNAME=$KAFKA_SASL_USERNAME \
  -e KAFKA_SASL_PASSWORD=$KAFKA_SASL_PASSWORD \
  --name teste-ruby-karafka-confluent ruby-karafka-confluent bundle exec karafka s
