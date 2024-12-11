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
import io.ballerina.runtime.api.creators.ValueCreator;
import io.ballerina.runtime.api.types.PredefinedTypes;
import io.ballerina.runtime.api.utils.JsonUtils;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.ValueUtils;
import io.ballerina.runtime.api.values.BArray;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BObject;
import io.ballerina.runtime.api.values.BTypedesc;

import java.nio.ByteBuffer;

import static io.ballerina.lib.confluent.avro.serdes.ModuleUtils.getModule;

/**
 * Provide APIs related to Avro Serialization/Deserialization with the Schema Registry.
 */
public class AvroDeserializer {
    private static final String DESERIALIZE_FUNCTION = "deserializeData";
    private static final String DESERIALIZER = "Deserializer";

    public static Object deserialize(Environment env, BObject registry, BArray data, BTypedesc typeDesc) {
        BObject deserializer = ValueCreator.createObjectValue(getModule(), DESERIALIZER, null, null);
        return env.yieldAndRun(() -> {
            try {
                Object[] arguments = new Object[]{registry, data, typeDesc};
                Object result = env.getRuntime().callMethod(deserializer, DESERIALIZE_FUNCTION, null, arguments);
                if (result instanceof BError) {
                    return result;
                } else {
                    Object jsonObject = JsonUtils.parse(StringUtils.getJsonString(result));
                    return ValueUtils.convert(jsonObject, typeDesc.getDescribingType());
                }
            } catch (BError bError) {
                return bError;
            }
        });
    }

    public static BArray toBytes(int id) {
        byte[] value = ByteBuffer.allocate(5).put((byte) 0).putInt(id).array();
        return ValueCreator.createArrayValue(value);
    }

    public static int getId(BArray bytes) {
        return ByteBuffer.wrap(bytes.getByteArray()).getInt();
    }
}
