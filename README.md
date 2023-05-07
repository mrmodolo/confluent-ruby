# Karafka SASL

[karafka](https://github.com/karafka/karafka)

# Requisitos para conexão e consumo

- Não é permitido a criação de tópicos de forma automática (**allow.auto.create.topics: false**);
- Todo consumer deve ter um **consumer group id** definido;
- O consumer group deve ter um **prefixo aceito pela ACL Confluent**;
- Toda URL pública deve usar SASL com usuário e senha;
  - 'security.protocol': 'SASL_SSL'
  - 'sasl.mechanisms': 'PLAIN'

# Requisitos para conexão e envio de mensagens

- Não é permitido a criação de tópicos de forma automática (**allow.auto.create.topics: false**);
- Toda URL pública deve usar SASL com usuário e senha;
  - 'security.protocol': 'SASL_SSL'
  - 'sasl.mechanisms': 'PLAIN'

## Configurações

Os scripts assumem um arquivo de configuração com as váriáveis abaixo.
O caminho default para o script é ```~/.confluent/karafka.config```

```bash
KAFKA_BOOTSTRAP_SERVERS
KAFKA_CLIENT_ID
KAFKA_GROUP_ID_PREFIX
KAFKA_SASL_PASSWORD
KAFKA_SASL_USERNAME
```
## Consumindo com o karafka

No karafka, a forma mais fácil de configurar o prefixo para o **group_id** 
é usando o **client_id**.

A estratégia do karafka é combinar o **client_id** com o **raw_consumer_group_name**
usado na rota. Se o **client_id** for definido como **meu_cliente** e o **raw_consumer_group_name**
(consumer_group) como **meu_grupo** o resultado será **meu_cliente_meu_grupo**.

Assim, basta que o **client_id** seja configurado com o prefixo estabelecido pela ACL Confluent (lembre que o 
karafka adiciona o '_' sublinhado de forma automática).

É possível também, usar uma classe para criar um consumer mapper especializado.

## Consumer mappers

[Consumer mappers](https://karafka.io/docs/Consumer-mappers/)

Karafka has a default strategy for consumer ids. Each consumer group id is a combination of the group name taken 
from the routing and the client_id. This is a really good convention for new applications and systems, however, 
if you migrate from other tools, you may want to preserve your different naming convention. 
To do so, you can implement a consumer mapper that will follow your conventions.

Mapper needs to implement the following method:

call - accepts raw consumer group name, should return remapped id.

```ruby
class MyCustomConsumerMapper
  # @param raw_consumer_group_name [String, Symbol] raw consumer group name
  # @return [String] remapped final consumer group name
  def call(raw_consumer_group_name)
    raw_consumer_group_name
  end
end
```

In order to use it, assign it as your default consumer_mapper:

```ruby
class KarafkaApp < Karafka::App
  setup do |config|
    config.consumer_mapper = MyCustomConsumerMapper.new
    # Other config options
  end
end
```

## Default Consumer mapper

Olhando o código em ```lib/karafka/routing/consumer_mapper.rb``` percebi que o 
group_id é uma combinação do client_id e do raw_consumer_group_name usado como rota,
assim, basta usar como client_id o valor 'baas' para que o consumo funcione.


```ruby
module Karafka
  module Routing
    # Default consumer mapper that builds consumer ids based on app id and consumer group name
    # Different mapper can be used in case of preexisting consumer names or for applying
    # other naming conventions not compatible with Karafka client_id + consumer name concept
    #
    # @example Mapper for using consumer groups without a client_id prefix
    #   class MyMapper
    #     def call(raw_consumer_group_name)
    #       raw_consumer_group_name
    #     end
    #   end
    class ConsumerMapper
      # @param raw_consumer_group_name [String, Symbol] string or symbolized consumer group name
      # @return [String] remapped final consumer group name
      def call(raw_consumer_group_name)
        "#{Karafka::App.config.client_id}_#{raw_consumer_group_name}"
      end
    end
  end
end
```

## Exemplo

Para criar a imagem, rodar o servidor e enviar mensagens é 
necessário ter o Docker ou o Podman/Buildah instalados.

Além disso é necessário também criar o arquivo de configuração para a conexão.


### Constrói a imagem

```bash
./build.sh
```
### Roda o servidor (consome as mensagens)

```bash
run_server.sh
```
### Envia uma mensagem

```bash
send_message.sh
```
