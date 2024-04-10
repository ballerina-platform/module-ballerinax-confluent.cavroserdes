# Specification: Ballerina Avro Serializer/Deserializer for Confluent Schema Registry Library

_Authors_: @Nuvindu \
_Reviewers_: @ThisaruGuruge \
_Created_: 2024/04/10 \
_Updated_: 2024/04/10 \
_Edition_: Swan Lake

## Introduction

The Ballerina Avro Serializer/Deserializer for Confluent Schema Registry module facilitates the integration with Confluent's Schema Registry and Avro. It offers capabilities to serialize and deserialize Avro data using the schemas stored in the registry.

The Avro Serializer/Deserializer library specification has evolved and may continue to evolve in the future. The released versions of the specification can be found under the relevant GitHub tag.

For feedback or suggestions about the library, please initiate a discussion via a [GitHub issue](https://github.com/ballerina-platform/ballerina-library/issues) or in the [Discord server](https://discord.gg/ballerinalang). The specification and implementation can be updated based on the discussion's outcome. Community feedback is highly appreciated. Accepted proposals that affect the specification are stored under `/docs/proposals`. Proposals under discussion can be found with the label `type/proposal` in GitHub.

The conforming implementation of the specification is released and included in the distribution. Any deviation from the specification is considered a bug.

## Contents

1. [Overview](#1-overview)
2. [Initialize the Avro Serializer/Deserializer client](#2-initialize-the-avro-serializerdeserializer-client)
    * 2.1 [The `init` method](#21-the-init-method)
3. [Serialize data](#3-serialize-data)
    * 3.1 [The `serialize` API](#31-the-serialize-api)
4. [Deserialize data](#4-deserialize-data)
    * 4.1 [The `deserialize` API](#41-the-deserialize-api)
5. [The `cavroserdes:Error` Type](#5-the-cavroserdeserror-type)

## 1. Overview

This specification provides a detailed explanation of the functionalities offered by the Ballerina Avro Serializer/Deserializer for Confluent Schema Registry module. The module provides the following capabilities.

1. Serialize data
2. Deserialize data

## 2. Initialize the Avro Serializer/Deserializer client

The Avro Serializer/Deserializer client needs to be initialized before performing the functionalities.

### 2.1 The `init` method

The `init` method initializes the Avro Serializer/Deserializer client. It takes a `config` parameter, which contains the necessary configuration to connect to the Schema Registry. The method returns an error if the initialization fails.

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

## 3. Serialize data

The Avro Serializer/Deserializer module allows serializing data to Avro format using the schemas from the registry.

### 3.1 The `serialize` API

The `serialize` method serializes a given value to Avro format using the provided schema and subject. Here the new schemas added on a particular `subject` must have backward compatibility with previous versions of schemas on that `subject`.

```ballerina
string schema = string `
{
    "type": "int",
    "name" : "value", 
    "namespace": "data"
}`;

int value = 1;
byte[] bytes = check avroSerDes.serialize(schema, value, "subject");
```

## 4. Deserialize data

This section details the process of deserializing Avro data using the schemas from the registry.

### 4.1 The `deserialize` API

The `deserialize` method deserializes a given Avro data to its original form using the schema from the registry.

```ballerina
int number = check avroSerDes.deserialize(bytes);
```

## 5. The `cavroserdes:Error` Type

The `cavroserdes:Error` type represents all the errors related to the Avro Serializer/Deserializer for Confluent Schema Registry module. This is a subtype of the Ballerina `error` type.
