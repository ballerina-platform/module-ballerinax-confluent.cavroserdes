// Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com)
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/avro;
import ballerina/jballerina.java;
import ballerinax/confluent.cregistry;

# Consists of APIs to integrate with Avro Serializer/Deserializer for Confluent Schema Registry.
public isolated client class Client {
    private final cregistry:Client schemaClient;

    public isolated function init(*cregistry:ConnectionConfig config) returns Error? {
        cregistry:Client|error schemaClient = new (config);
        if schemaClient is error {
            return error Error("Client invocation error", schemaClient);
        }
        self.schemaClient = schemaClient;
    }

    remote isolated function serialize(string schema, anydata data, string topic) returns byte[]|Error {
        do {
            int id = check self.schemaClient->register(topic, schema);
            byte[] encodedId = check self.toBytes(id);
            avro:Schema avroClient = check new (schema);
            byte[] serializedData = check avroClient.toAvro(data);
            return [...encodedId, ...serializedData];
        } on fail error e {
            return error Error(SERIALIZATION_ERROR, e);
        }
    }

    remote isolated function deserialize(byte[] data, typedesc<anydata> T = <>)
        returns T|Error = @java:Method {
        'class: "io.ballerina.lib.confluent.avro.serdes.AvroSerializer"
    } external;

    private isolated function toBytes(int id) returns byte[]|error = @java:Method {
        'class: "io.ballerina.lib.confluent.avro.serdes.AvroSerializer"
    } external;

    private isolated function getId(byte[] bytes) returns int = @java:Method {
        'class: "io.ballerina.lib.confluent.avro.serdes.AvroSerializer"
    } external;

    public isolated function deserializeData(byte[] data) returns anydata|Error {
        do {
            int schemaId = self.getId(data.slice(0, 4));
            string retrievedSchema = check self.schemaClient->getSchemaById(schemaId);
            avro:Schema avroClient = check new (retrievedSchema);
            anydata deserializedData = check avroClient.fromAvro(data.slice(4, data.length()));
            return deserializedData;
        } on fail error e {
            return error Error(DESERIALIZATION_ERROR, e);
        }
    }
}
