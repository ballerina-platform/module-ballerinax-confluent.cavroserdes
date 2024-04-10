# Publish Avro Serialized Data to a Kafka Topic

## Introduction

This guide demonstrates how to publish Avro serialized data to a Kafka topic.

### Configuration

Configure the followings in `Config.toml` in the directory.

```toml
baseUrl = "<BASE_URL>"
identityMapCapacity = <SCHEMA_MAP_CAPACITY>
subject = "<SCHEMA_REGISTRY_TOPIC>"

[originals]
"schema.registry.url" = "<SCHEMA_REGISTRY_ENDPOINT_URL>"
"basic.auth.credentials.source" = "USER_INFO"
"bootstrap.servers" = "<SERVER>:<PORT>"
"schema.registry.basic.auth.user.info" = "<KEY>:<SECRET>"

[headers]
```

## Run the example

Execute the following command to run the example.

```ballerina
bal run
```
