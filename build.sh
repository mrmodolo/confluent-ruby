#!/usr/bin/env bash

run_container() {
  ${RUNTIME} build -t ruby-karafka-confluent .
}

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

