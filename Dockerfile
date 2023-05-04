FROM ruby:2.7.8-bullseye

RUN useradd -ms /bin/bash confluent

WORKDIR /home/confluent

USER confluent

COPY ./.diffend.yml .

COPY ./Gemfile .

RUN /usr/local/bin/bundle install 

RUN /usr/local/bin/bundle exec karafka install

COPY ./karafka.rb .

