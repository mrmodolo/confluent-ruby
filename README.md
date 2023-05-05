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

## Default Consummer mapper

Olhando o código em ```lib/karafka/routing/consumer_mapper.rb``` percebi que o 
group_id é uma combinação do client_id + _ + o consumer group name usado na rota,
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
