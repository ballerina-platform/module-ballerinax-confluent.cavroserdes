## Examples

The Ballerina Avro Serializer/Deserializer connector for Confluent Schema Registry provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/tree/main/examples).

1. [Kafka Avro producer](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/tree/main/examples/kafka-avro-producer)
    This example shows how to publish Avro serialized data to a Kafka topic.

2. [Kafka Avro consumer](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/tree/main/examples/kafka-avro-consumer)
    This guide demonstrates how to consume data in the correct format according to Avro schema from a Kafka topic.

## Prerequisites

Create a `Config.toml` file with the base URL, schema capacity, subject, connection configurations and header values. Here's an example of how your `Config.toml` file should look:

    ```toml
    baseUrl = <BASE_URL>
    identityMapCapacity = <SCHEMA_MAP_CAPACITY>
    subject = <SCHEMA_REGISTRY_TOPIC>

    [originals]
    "schema.registry.url" = <SCHEMA_REGISTRY_ENDPOINT_URL>
    "basic.auth.credentials.source" = "USER_INFO"
    "bootstrap.servers" = "<SERVER>:<PORT>"
    "schema.registry.basic.auth.user.info" = "<KEY>:<SECRET>"

    [headers]
    ```

## Running an Example

Follow these steps to run the examples.

## Step 01: Start a Kafka Server

Execute the following docker command to start the Kafka server.

```bash
sudo docker-compose -f docker-compose.yaml up -d
```

## Step 02: Start the Kafka Producer

Go to the [kafka-avro-producer](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/tree/main/examples/kafka-avro-producer) directory and start the Ballerina service.

```bash
bal run
```

## Step 03: Run the Kafka Consumer

Go to the [kafka-avro-consumer](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/tree/main/examples/kafka-avro-consumer) directory and execute the following command.

```bash
bal run
```

## Step 04: Execute the cURL command

Execute the following curl command in a terminal.

```curl 
curl http://localhost:9090/orders -H "Content-type:application/json" -d "{\"orderId\": 1, \"productName\": \"sport-shoes\"}"
```
