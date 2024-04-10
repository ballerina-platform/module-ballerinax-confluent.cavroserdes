## Package overview

[Avro Serializer/Deserializer for Confluent Schema Registry](https://docs.confluent.io/platform/current/schema-registry/fundamentals/serdes-develop/serdes-avro.html) is an Avro serializer/deserializer designed to work with the Confluent Schema Registry. It is designed to not include the message schema in the message payload but instead includes the schema ID.

The Ballerina Avro Serializer/Deserializer for Confluent Schema Registry connector integrates with the Confluent Schema Registry for Avro serialization and deserialization.

## Quickstart

To use the Confluent schema registry connector in your Ballerina project, modify the `.bal` file as follows.

### Step 1: Import the module

Import the `ballerinax/confluent.cavroserdes` module into your Ballerina project.

```ballerina
import ballerinax/confluent.cavroserdes;
```

### Step 2: Instantiate a new connector

```ballerina
configurable string baseUrl = ?;
configurable int identityMapCapacity = ?;
configurable map<anydata> originals = ?;
configurable map<string> headers = ?;

cavroserdes:Client avroSerDes = check new ({
    baseUrl,
    identityMapCapacity,
    originals,
    headers
});
```

### Step 3: Invoke the connector operation

You can now utilize the operations available within the connector.

```ballerina
public function main() returns error? {
   string schema = string `
      {
         "type": "int",
         "name" : "value", 
         "namespace": "data"
      }`;

   int value = 1;
   byte[] bytes = check avroSerDes.serialize(schema, value, "subject");
   int number = check avroSerDesClient.deserialize(bytes);
}
```
