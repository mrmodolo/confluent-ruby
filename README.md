# Karafka SASL


## Configurações

Os scripts assumem um arquivo de configuração com as váriáveis abaixo.
O caminho default para o script é ```~/.confluent/karafka.config```

```bash
KAFKA_GROUP_ID_PREFIX
KAFKA_BOOTSTRAP_SERVERS
KAFKA_SASL_USERNAME
KAFKA_SASL_PASSWORD
KAFKA_CLIENT_ID
```
## Exemplo

### Cosntroi a imagmem

```bash
./build.sh
```

### Roda o servidor que consome as mensagens

```bash
run_server.sh
```

### Envia uma mensagem

```bash
send_message.sh
```
