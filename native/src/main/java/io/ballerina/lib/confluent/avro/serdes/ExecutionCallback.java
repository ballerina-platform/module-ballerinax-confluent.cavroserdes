/*
 * Copyright (c) 2024, WSO2 LLC. (http://www.wso2.org) All Rights Reserved.
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

import io.ballerina.runtime.api.Future;
import io.ballerina.runtime.api.async.Callback;
import io.ballerina.runtime.api.utils.JsonUtils;
import io.ballerina.runtime.api.utils.StringUtils;
import io.ballerina.runtime.api.utils.ValueUtils;
import io.ballerina.runtime.api.values.BError;
import io.ballerina.runtime.api.values.BTypedesc;

public class ExecutionCallback implements Callback {
    private final Future future;
    private final BTypedesc typeDesc;

    ExecutionCallback(Future future, BTypedesc typeDesc) {
        this.future = future;
        this.typeDesc = typeDesc;
    }
    @Override
    public void notifySuccess(Object o) {
        Object jsonObject = JsonUtils.parse(StringUtils.getJsonString(o));
        this.future.complete(ValueUtils.convert(jsonObject, typeDesc.getDescribingType()));
    }

    @Override
    public void notifyFailure(BError bError) {
        this.future.complete(bError);
    }
}
