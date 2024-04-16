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

# Serializes the given data according to the Avro format and registers the schema into the schema registry.
#
# + registry - The schema registry client
# + schema - The Avro schema
# + data - The data to be serialized according to the schema
# + subject - The subject under which the schema should be registered
# + return - A `byte` array of the serialized data or else an `cavroserdes:Error`
public isolated function serialize(cregistry:Client registry, string schema, anydata data,
                                    string subject) returns byte[]|Error {
    do {
        int id = check registry->register(subject, schema);
        byte[] encodedId = check toBytes(id);
        avro:Schema avroClient = check new (schema);
        byte[] serializedData = check avroClient.toAvro(data);
        return [...encodedId, ...serializedData];
    } on fail error e {
        return error Error(SERIALIZATION_ERROR, e);
    }
}

# Deserializes the given Avro serialized message to the given data type by retrieving the schema 
# from the schema registry.
#
# + registry - The schema registry client
# + data - Avro serialized data which includes the schema id
# + targetType - Default parameter use to infer the user specified type
# + return - A deserialized data with the given type or else an `cavroserdes:Error`
public isolated function deserialize(cregistry:Client registry, byte[] data, typedesc<anydata> targetType = <>)
    returns targetType|Error = @java:Method {
    'class: "io.ballerina.lib.confluent.avro.serdes.AvroDeserializer"
} external;

isolated function toBytes(int id) returns byte[]|error = @java:Method {
    'class: "io.ballerina.lib.confluent.avro.serdes.AvroDeserializer"
} external;

isolated function getId(byte[] bytes) returns int = @java:Method {
    'class: "io.ballerina.lib.confluent.avro.serdes.AvroDeserializer"
} external;

class Deserializer {
    isolated function deserializeData(cregistry:Client registry, byte[] data) returns anydata|Error {
        do {
            int schemaId = getId(data.slice(1, 5));
            string retrievedSchema = check registry->getSchemaById(schemaId);
            avro:Schema avroClient = check new (retrievedSchema);
            anydata deserializedData = check avroClient.fromAvro(data.slice(5, data.length()));
            return deserializedData;
        } on fail error e {
            return error Error(DESERIALIZATION_ERROR, e);
        }
    }
}
