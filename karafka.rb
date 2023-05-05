# frozen_string_literal: true

# This file is auto-generated during the install process.
# If by any chance you've wanted a setup for Rails app, either run the `karafka:install`
# command again or refer to the install templates available in the source codes

ENV['KARAFKA_ENV'] ||= 'development'
Bundler.require(:default, ENV['KARAFKA_ENV'])

# Zeitwerk custom loader for loading the app components before the whole
# Karafka framework configuration
APP_LOADER = Zeitwerk::Loader.new
APP_LOADER.enable_reloading

%w[
  lib
  app/consumers
].each { |dir| APP_LOADER.push_dir(dir) }

APP_LOADER.setup
APP_LOADER.eager_load

# https://karafka.io/docs/Consumer-mappers/
# Karafka has a default strategy for consumer ids. 
# Each consumer group id is a combination of the group name taken 
# from the routing and the client_id. 
# This is a really good convention for new applications and systems, 
# however, if you migrate from other tools, you may want to preserve 
# your different naming convention. To do so, you can implement a 
# consumer mapper that will follow your conventions.
class ConfluentACLPrefixConsumerMapper
  def initialize(prefix = "")
    @prefix = prefix
  end

  # @param raw_consumer_group_name [String, Symbol] raw consumer group name
  # @return [String] remapped final consumer group name
  def call(raw_consumer_group_name)
    Karafka.logger.info "consumer_group_name: #{@prefix}#{raw_consumer_group_name}"
    @prefix + raw_consumer_group_name
  end
end

class KarafkaApp < Karafka::App
  setup do |config|
    config.consumer_mapper = ConfluentACLPrefixConsumerMapper.new(ENV.fetch('KAFKA_GROUP_ID_PREFIX',''))
    config.kafka = { 
      'bootstrap.servers': "#{ENV.fetch('KAFKA_BOOTSTRAP_SERVERS','localhost:9092')}",
      'security.protocol': 'SASL_SSL',
      'sasl.mechanisms': 'PLAIN',
      'sasl.username': "#{ENV['KAFKA_SASL_USERNAME']}",
      'sasl.password': "#{ENV['KAFKA_SASL_PASSWORD']}",
    }
    config.client_id = "#{ENV.fetch('KAFKA_CLIENT_ID','example_app')}"
    Karafka.logger.info "config.client_id: #{config.client_id}"
  end

  # Comment out this part if you are not using instrumentation and/or you are not
  # interested in logging events for certain environments. Since instrumentation
  # notifications add extra boilerplate, if you want to achieve max performance,
  # listen to only what you really need for given environment.
  Karafka.monitor.subscribe(Karafka::Instrumentation::LoggerListener.new)
  # Karafka.monitor.subscribe(Karafka::Instrumentation::ProctitleListener.new)

  # This logger prints the producer development info using the Karafka logger.
  # It is similar to the consumer logger listener but producer oriented.
  Karafka.producer.monitor.subscribe(
    WaterDrop::Instrumentation::LoggerListener.new(Karafka.logger)
  )

  routes.draw do
    consumer_group :teste_2 do
      topic :partnerNotifications_baas_v0 do
        # Uncomment this if you want Karafka to manage your topics configuration
        # Managing topics configuration via routing will allow you to ensure config consistency
        # across multiple environments
        #
        config(partitions: 1, 'cleanup.policy': 'compact')
        consumer ExampleConsumer
      end
    end
  end
end
