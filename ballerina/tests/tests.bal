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

import ballerina/test;
import ballerinax/confluent.cregistry;

configurable string baseUrl = ?;
configurable int identityMapCapacity = ?;
configurable map<anydata> originals = ?;
configurable map<string> headers = ?;

cregistry:Client regsitry = check new ({
    baseUrl,
    identityMapCapacity,
    originals,
    headers
});

@test:Config {}
public function testSerDes() returns error? {
    string schema = string `
        {
            "namespace": "example.avro",
            "type": "record",
            "name": "Student",
            "fields": [
                {"name": "name", "type": "string"},
                {"name": "colors", "type": {"type": "array", "items": "string"}}
            ]
        }`;

    Color colors = {
        name: "Red",
        colors: ["maroon", "dark red", "light red"]
    };
    byte[] bytes = check serialize(regsitry, schema, colors, "subject-0");
    Color getColors = check deserialize(regsitry, bytes);
    test:assertEquals(getColors, colors);
}

@test:Config {}
public function testWithRecords() returns error? {
    string schema = string `
        {
            "namespace": "example.avro",
            "type": "record",
            "name": "Student",
            "fields": [
                {"name": "name", "type": "string"},
                {"name": "subject", "type": "string"}
            ]
        }`;

    Student student = {
        name: "John",
        subject: "Math"
    };

    byte[] bytes = check serialize(regsitry, schema, student, "subject-1");
    Student getStudent = check deserialize(regsitry, bytes);
    test:assertEquals(getStudent, student);
}

@test:Config {}
public function testWithRecordsBindingToAnydata() returns error? {
    string schema = string `
        {
            "namespace": "example.avro",
            "type": "record",
            "name": "Student",
            "fields": [
                {"name": "name", "type": "string"},
                {"name": "subject", "type": "string"}
            ]
        }`;

    Student student = {
        name: "John",
        subject: "Math"
    };

    byte[] bytes = check serialize(regsitry, schema, student, "subject-1");
    anydata getStudent = check deserialize(regsitry, bytes);
    test:assertEquals(getStudent.cloneWithType(Student), student);
}

@test:Config {}
public function testSerDesWithInteger() returns error? {
    string schema = string `
        {
            "type": "int",
            "name" : "intValue", 
            "namespace": "data"
        }`;

    int value = 1;

    byte[] bytes = check serialize(regsitry, schema, value, "subject-5");
    int getValue = check deserialize(regsitry, bytes);
    test:assertEquals(getValue, value);
}

@test:Config {}
public function testSerDesWithCourse() returns error? {
    string schema = string `
        {
            "namespace": "example.avro",
            "type": "record",
            "name": "Course",
            "fields": [
                {"name": "name", "type": ["null", "string"]},
                {"name": "credits", "type": ["null", "int"]}
            ]
        }`;

    Course course = {
        name: "Physics",
        credits: 3
    };

    byte[] bytes = check serialize(regsitry, schema, course, "subject-3");
    Course getCourse = check deserialize(regsitry, bytes);
    test:assertEquals(getCourse, course);
}

public type Student record {
    string name;
    string subject;
};

public type Person record {
    string name;
    int age;
};

public type Course record {
    string? name;
    int? credits;
};

public type Color record {
    string? name;
    string[] colors;
};
