# Ballerina Confluent Avro Serialization/Deserialization Connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/actions/workflows/ci.yml)
[![Trivy](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/actions/workflows/trivy-scan.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/actions/workflows/trivy-scan.yml)
[![GraalVM Check](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/actions/workflows/build-with-bal-test-graalvm.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/actions/workflows/build-with-bal-test-graalvm.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-confluent.cavroserdes.svg)](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/confluent.cavroserdes.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Fconfluent.cavroserdes)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

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
   byte[] bytes = check avroSerDes->serialize(schema, value, "subject");
   int number = check avroSerDes->deserialize(bytes);
}
```

### Step 4: Run the Ballerina application

Use the following command to compile and run the Ballerina program.

```bash
bal run
```

## Examples

The Ballerina Avro Serializer/Deserializer connector for Confluent Schema Registry provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/tree/main/examples).

1. [Kafka Avro producer](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/tree/main/examples/kafka-avro-producer)
    This example shows how to publish Avro serialized data to a Kafka topic.

2. [Kafka Avro consumer](https://github.com/ballerina-platform/module-ballerinax-confluent.cavroserdes/tree/main/examples/kafka-avro-consumer)
    This guide demonstrates how to consume data in the correct format according to Avro schema from a Kafka topic.

## Issues and projects

The **Issues** and **Projects** tabs are disabled for this repository as this is part of the Ballerina library. To report bugs, request new features, start new discussions, view project boards, etc., visit the Ballerina library [parent repository](https://github.com/ballerina-platform/ballerina-library).

This repository only contains the source code for the package.

## Building from the source

### Prerequisites

1. Download and install Java SE Development Kit (JDK) version 17. You can download it from either of the following sources:

   - [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
   - [OpenJDK](https://adoptium.net/)

    > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

    > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Generate a Github access token with read package permissions, then set the following `env` variables:

    ```bash
   export packageUser=<Your GitHub Username>
   export packagePAT=<GitHub Personal Access Token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To debug package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

5. To debug with Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

6. Publish the generated artifacts to the local Ballerina central repository:

   ```bash
   ./gradlew clean build -PpublishToLocalCentral=true
   ```

7. Publish the generated artifacts to the Ballerina central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contributing to Ballerina

As an open source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

- For more information go to the [confluent.cavroderdes](https://central.ballerina.io/ballerinax/confluent.cavroserdes/latest) library.
- Discuss code changes of the Ballerina project in [ballerina-dev@googlegroups.com](mailto:ballerina-dev@googlegroups.com).
- Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
- Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
