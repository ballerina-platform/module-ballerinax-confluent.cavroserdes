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

import ballerina/http;
import ballerinax/confluent.cavroserdes;
import ballerinax/confluent.cregistry;
import ballerinax/kafka;

configurable string baseUrl = ?;
configurable map<anydata> originals = ?;
configurable map<string> headers = ?;

type Order readonly & record {
    int orderId;
    string productName;
};

service / on new http:Listener(9090) {
    private final kafka:Producer orderProducer;
    private final cregistry:Client registry;

    function init() returns error? {
        self.orderProducer = check new (kafka:DEFAULT_URL);
        self.registry = check new ({
            baseUrl,
            originals,
            headers
        });
    }

    resource function post orders(Order newOrder) returns http:Accepted|error {
        string schema = string `
            {
                "namespace": "example.avro",
                "type": "record",
                "name": "Order",
                "fields": [
                    {"name": "orderId", "type": "int"},
                    {"name": "productName", "type": "string"}
                ]
            }`;

        byte[] byteValue = check cavroserdes:serialize(self.registry, schema, newOrder, "new-subject");
        check self.orderProducer->send({
            topic: "test-topic",
            value: byteValue
        });
        return http:ACCEPTED;
    }
}
