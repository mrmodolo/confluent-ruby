#!/bin/bash

CONFIG_FILE="${HOME}/.confluent/karafka.config"

run_container() {
${RUNTIME} run -it --rm \
  -e KAFKA_CLIENT_ID=$KAFKA_CLIENT_ID \
  -e KAFKA_GROUP_ID_PREFIX=$KAFKA_GROUP_ID_PREFIX \
  -e KAFKA_BOOTSTRAP_SERVERS=$KAFKA_BOOTSTRAP_SERVERS \
  -e KAFKA_SASL_USERNAME=$KAFKA_SASL_USERNAME \
  -e KAFKA_SASL_PASSWORD=$KAFKA_SASL_PASSWORD \
  --name teste-ruby-karafka-confluent ruby-karafka-confluent bundle exec karafka s
}

if [ ! -f "${CONFIG_FILE}" ]
then
  echo "O arquivo de configuração em ${CONFIG_FILE} não foi encontrado."
  echo "As variáveis abaixo necessitam ser definidas:"
  echo "  KAFKA_CLIENT_ID"
  echo "  KAFKA_GROUP_ID_PREFIX"
  echo "  KAFKA_BOOTSTRAP_SERVERS"
  echo "  KAFKA_SASL_USERNAME"
  echo "  KAFKA_SASL_PASSWORD"
  exit 1
fi

source ${CONFIG_FILE}

# Eu prefiro o podman
RUNTIME=$(which podman)

if [[ ${RUNTIME} && $(${RUNTIME} --version) ]]
then
  run_container
else
  # Não temos o podman vamos tentar com o docker
    RUNTIME=$(which docker)
    if [[ ${RUNTIME} && $(${RUNTIME} --version) ]]
    then
      run_container
    else
      echo "É necessário que o podman ou docker estejam instalados"
      exit 1
    fi
fi

exit 0

