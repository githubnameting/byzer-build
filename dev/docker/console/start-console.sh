#!/usr/bin/env bash
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

BYZER_CONSOLE_VERSION=${BYZER_CONSOLE_VERSION:-2.2.0-SNAPSHOT}
BYZER_CONSOLE_HOME=${BYZER_CONSOLE_HOME:-/home/deploy/byzer-console}
BYZER_ENGINE_URL=${BYZER_ENGINE_URL:-"http://127.0.0.1:9003"}

echo "Starting console"
echo "BYZER_CONSOLE_VERSION ${BYZER_CONSOLE_VERSION}"
echo "BYZER_CONSOLE_HOME ${BYZER_CONSOLE_HOME}"
echo "BYZER_ENGINE_URL ${BYZER_ENGINE_URL}"
echo -ex

## Start byzer-api-console
java -cp ${BYZER_CONSOLE_HOME}/libs/byzer-api-console-${BYZER_CONSOLE_VERSION}.jar:./ tech.byzer.BYZERConsole \
-byzer_engine_url ${BYZER_ENGINE_URL} \
-my_url http://localhost:9002 \
-user_home /work/user/ \
-enable_auth_center false \
-config ${BYZER_CONSOLE_HOME}/conf/application.yml
