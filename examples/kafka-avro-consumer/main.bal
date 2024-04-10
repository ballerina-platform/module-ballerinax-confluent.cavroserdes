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

import ballerina/io;
import ballerinax/confluent.cavroserdes;
import ballerinax/kafka;

type Order readonly & record {
    int orderId;
    string productName;
};

configurable string baseUrl = ?;
configurable int identityMapCapacity = ?;
configurable map<anydata> originals = ?;
configurable map<string> headers = ?;

public function main() returns error? {
    kafka:Consumer orderConsumer = check new (kafka:DEFAULT_URL, {
        groupId: "test-topic-id",
        topics: "test-topic"
    });

    cavroserdes:Client registry = check new ({
        baseUrl,
        identityMapCapacity,
        originals,
        headers
    });

    while true {
        kafka:AnydataConsumerRecord[] getValues = check orderConsumer->poll(60);
        byte[] orderData = <byte[]>getValues[0].value;
        Order getOrder = check registry->deserialize(orderData);
        io:println("Order : ", getOrder);
    }
}
