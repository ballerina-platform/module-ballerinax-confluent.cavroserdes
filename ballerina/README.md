## Overview

[Avro Serializer/Deserializer for Confluent Schema Registry](https://docs.confluent.io/platform/current/schema-registry/fundamentals/serdes-develop/serdes-avro.html) is an Avro serializer/deserializer designed to work with the Confluent Schema Registry. It is designed to not include the message schema in the message payload but instead includes the schema ID.

The Ballerina Avro Serializer/Deserializer for Confluent Schema Registry connector integrates with the Confluent Schema Registry for Avro serialization and deserialization.

## Quickstart

To use the Confluent schema registry connector in your Ballerina project, modify the `.bal` file as follows.

### Step 1: Import the module

Import the `ballerinax/confluent.cavroserdes` module into your Ballerina project.

```ballerina
import ballerinax/confluent.cavroserdes;
```

### Step 2: Invoke the connector operation

You can now utilize the operations available within the connector. To instantiate a `cregistry:Client` instance refer to the guidelines [here](https://central.ballerina.io/ballerinax/confluent.cregistry/latest).

```ballerina
public function main() returns error? {
   cregistry:Client registry = ; // instantiate a schema registry client

   string schema = string `
      {
         "type": "int",
         "name" : "value", 
         "namespace": "data"
      }`;

   int value = 1;
   byte[] bytes = check cavroserdes:serialize(registry, schema, value, "subject");
   int number = check cavroserdes:deserialize(registry, bytes);
}
```

### Step 3: Run the Ballerina application

Use the following command to compile and run the Ballerina program.

```bash
bal run
```

## Examples

The Ballerina Avro Serializer/Deserializer connector for Confluent Schema Registry provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/tree/main/examples).

1. [Kafka Avro producer](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/tree/main/examples/kafka-avro-producer) - This example demonstrates how to publish Avro serialized data to a Kafka topic.

2. [Kafka Avro consumer](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/tree/main/examples/kafka-avro-consumer) - This guide demonstrates how to consume data in the correct format according to the Avro schema from a Kafka topic.
