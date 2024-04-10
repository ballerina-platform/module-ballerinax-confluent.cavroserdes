/*
 * Copyright (c) 2024, WSO2 LLC. (http://www.wso2.com)
 *
 * WSO2 LLC. licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except
 * in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied. See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package io.ballerina.lib.confluent.avro.serdes;

import io.ballerina.runtime.api.Environment;
import io.ballerina.runtime.api.Future;
import io.ballerina.runtime.api.PredefinedTypes;
import io.ballerina.runtime.api.async.StrandMetadata;
import io.ballerina.runtime.api.creators.TypeCreator;
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.UnionType;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BTypedesc;

import java.nio.ByteBuffer;

import static io.ballerina.lib.confluent.avro.serdes.ModuleUtils.getModule;

/**
 * Provide APIs related to Avro Serialization/Deserialization with the Schema Registry.
 */
public class AvroSerializer {
    private static final String DESERIALIZE_FUNCTION = "deserializeData";

    public static final StrandMetadata EXECUTION_STRAND = new StrandMetadata(
            getModule().getOrg(),
            getModule().getName(),
            getModule().getMajorVersion(),
            DESERIALIZE_FUNCTION);

    public static Object deserialize(Environment env, BObject kafkaSerDes, BObject registry, BArray data,
                                     BTypedesc typeDesc) {
        Future future = env.markAsync();
        ExecutionCallback executionCallback = new ExecutionCallback(future, typeDesc);
        Object[] arguments = new Object[]{registry, true, data, true};
        UnionType typeUnion = TypeCreator.createUnionType(PredefinedTypes.TYPE_ANYDATA_ARRAY,
                                                          PredefinedTypes.TYPE_ERROR);
        env.getRuntime()
                .invokeMethodAsyncConcurrently(kafkaSerDes, DESERIALIZE_FUNCTION, null, EXECUTION_STRAND,
                                               executionCallback, null, typeUnion, arguments);
        return null;
    }

    public static BArray toBytes(int id) {
        byte[] value = ByteBuffer.allocate(5).put((byte) 0).putInt(id).array();
        return ValueCreator.createArrayValue(value);
    }

    public static int getId(BArray bytes) {
        return ByteBuffer.wrap(bytes.getByteArray()).getInt();
    }
}
