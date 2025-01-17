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
set -u
set -e
set -o pipefail

# ie kolo-build root path
base_dir=$(cd "$(dirname $0)/../.." && pwd)
mlsql_console_path="${base_dir}/console"
byzer_notebook_path="${base_dir}/byzer-notebook"
base_image_path="${base_dir}/dev/docker/base"
mlsql_sandbox_path="${base_dir}/dev/docker/mlsql-sandbox"
lib_path=${base_dir}/dev/lib

# Many environment variables are inferred from SPARK_VERSION
export SPARK_VERSION=${SPARK_VERSION:-3.1.1}

#export MLSQL_CONSOLE_VERSION=${MLSQL_CONSOLE_VERSION:-2.2.1-SNAPSHOT}
export BYZER_NOTEBOOK_VERSION=${BYZER_NOTEBOOK_VERSION:-1.0.2-SNAPSHOT}
export BYZER_NOTEBOOK_HOME=$byzer_notebook_path

if [[ ${SPARK_VERSION} == "2.4.3" ]]
then
    export SPARK_TGZ_NAME="spark-${SPARK_VERSION}-bin-hadoop2.7"
    export HADOOP_TGZ_NAME="hadoop-2.7.0"
    export AZURE_BLOB_NAME="azure-blob_2.7-1.0-SNAPSHOT.jar"
    export SCALA_BINARY_VERSION=2.11
    export MLSQL_SPARK_VERSION=2.4
elif [[ ${SPARK_VERSION} == "3.1.1" ]]
then
    export SPARK_TGZ_NAME="spark-${SPARK_VERSION}-bin-hadoop3.2"
    export AZURE_BLOB_NAME="azure-blob_3.2-1.0-SNAPSHOT.jar"
    export HADOOP_TGZ_NAME="hadoop-3.2.2"
    export SCALA_BINARY_VERSION=2.12
    export MLSQL_SPARK_VERSION=3.0
else
    echo "Only Spark 2.4.3 or 3.1.1 is supported"
    exit 1
fi

cat << EOF
BYZER_LANG_VERSION ${BYZER_LANG_VERSION}
SPARK_VERSION ${SPARK_VERSION}
MLSQL_SPARK_VERSION ${MLSQL_SPARK_VERSION}
AZURE_BLOB_NAME ${AZURE_BLOB_NAME}
SPARK_TGZ_NAME ${SPARK_TGZ_NAME}
HADOOP_TGZ_NAME ${HADOOP_TGZ_NAME}
SCALA_BINARY_VERSION ${SCALA_BINARY_VERSION}
EOF

## Builds mlsql distribution tar ball
function build_kolo_lang_distribution {

    ## Download jars & packages if needed
    if [[ ! -f "${lib_path}/${SPARK_TGZ_NAME}.tgz" && ${SPARK_VERSION} == "3.1.1" ]]
    then
      (
        echo "Downloading Spark 3.1.1" &&
          cd "${lib_path}" &&
          local times_tried=0
        while [ $times_tried -le 3 ]; do
          echo "Downloading $times_tried"
          if curl -O https://archive.apache.org/dist/spark/spark-3.1.1/spark-3.1.1-bin-hadoop3.2.tgz && tar -zxvf spark-3.1.1-bin-hadoop3.2.tgz; then
            rm -rf "${lib_path}"/spark-3.1.1-bin-hadoop3.2
            break
          fi
          if [[ $times_tried -ge 3 ]];then
            echo "Download spark-3.1.1-bin-hadoop3.2 failed!" && exit 1;
          fi
          times_tried=$((times_tried + 1))
          rm -rf spark-3.1.1-bin-hadoop3.2.tgz
        done
      ) || exit 1
    fi

    if [[ ! -f "${lib_path}/${SPARK_TGZ_NAME}.tgz" && ${SPARK_VERSION} == "2.4.3" ]]
    then
        (
          echo "Downloading Spark 2.4.3" &&
            cd "${lib_path}" &&
            local times_tried=1
          while [ $times_tried -le 3 ]; do
            echo "Downloading $times_tried"
            if curl -O https://archive.apache.org/dist/spark/spark-2.4.3/spark-2.4.3-bin-hadoop2.7.tgz && tar -zxvf spark-2.4.3-bin-hadoop2.7.tgz; then
              rm -rf "${lib_path}"/spark-2.4.3-bin-hadoop2.7
              break
            fi
            if [[ $times_tried -ge 3 ]];then
              echo "Download spark-2.4.3-bin-hadoop2.7 failed!" && exit 1;
            fi
            times_tried=$((times_tried + 1))
            rm -rf spark-2.4.3-bin-hadoop2.7.tgz
          done
        ) || exit 1
    fi

    if [[ ! -f "${lib_path}/${HADOOP_TGZ_NAME}.tar.gz" && ${SPARK_VERSION} == "3.1.1" ]]
    then
      (
        echo "Downloading hadoop 3.2.2" &&
          cd "${lib_path}" &&
          local times_tried=0
        while [ $times_tried -le 3 ]; do
          echo "Downloading $times_tried"
          if curl -O https://dlcdn.apache.org/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz && tar -zxvf hadoop-3.2.2.tar.gz; then
            rm -rf "${lib_path}"/hadoop-3.2.2
            break
          fi
          if [[ $times_tried -ge 3 ]];then
            echo "Download hadoop-3.2.2.tar.gz failed!" && exit 1;
          fi
          times_tried=$((times_tried + 1))
          rm -rf hadoop-3.2.2.tar.gz
        done
      ) || exit 1
    fi

    if [[ ! -f "${lib_path}/${HADOOP_TGZ_NAME}.tar.gz" && ${SPARK_VERSION} == "2.4.3" ]]
    then
      (
        echo "Downloading hadoop 2.6.5" &&
          cd "${lib_path}" &&
          local times_tried=0
        while [ $times_tried -le 3 ]; do
          echo "Downloading $times_tried"
          if curl -O https://archive.apache.org/dist/hadoop/core/hadoop-2.7.0/hadoop-2.7.0.tar.gz && tar -zxvf hadoop-2.7.0.tar.gz; then
            rm -rf "${lib_path}"/hadoop-2.7.0
            break
          fi
          if [[ $times_tried -ge 3 ]];then
            echo "Download hadoop-2.7.0.tar.gz failed!" && exit 1;
          fi
          times_tried=$((times_tried + 1))
          rm -rf hadoop-2.7.0.tar.gz
        done
      ) || exit 1
    fi

    if [[ ! -f "${lib_path}/scala-${SCALA_BINARY_VERSION}.tgz" && ${SCALA_BINARY_VERSION} == "2.12" ]]
    then
      (
        echo "Downloading scala-${SCALA_BINARY_VERSION}" &&
          cd "${lib_path}" &&
          local times_tried=0
        while [ $times_tried -le 3 ]; do
          echo "Downloading $times_tried"
          if curl -O  https://downloads.lightbend.com/scala/2.12.10/scala-2.12.10.tgz && tar -zxvf scala-2.12.10.tgz; then
            rm -rf "${lib_path}"/scala-2.12.10
            mv "${lib_path}"/scala-2.12.10.tgz "${lib_path}"/scala-${SCALA_BINARY_VERSION}.tgz
            break
          fi
          if [[ $times_tried -ge 3 ]];then
            echo "Download scala-2.12.10.tgz failed!" && exit 1;
          fi
          times_tried=$((times_tried + 1))
          rm -rf scala-2.12.10.tgz
        done
      ) || exit 1
    fi

    if [[ ! -f "${lib_path}/scala-${SCALA_BINARY_VERSION}.tgz" && ${SCALA_BINARY_VERSION} == "2.11" ]]
    then
      (
        echo "Downloading scala-${SCALA_BINARY_VERSION}" &&
          cd "${lib_path}" &&
          local times_tried=0
        while [ $times_tried -le 3 ]; do
          echo "Downloading $times_tried"
          if curl -O https://downloads.lightbend.com/scala/2.11.12/scala-2.11.12.tgz && tar -zxvf scala-2.11.12.tgz; then
            rm -rf "${lib_path}"/scala-2.11.12
            mv "${lib_path}"/scala-2.12.10.tgz "${lib_path}"/scala-${SCALA_BINARY_VERSION}.tgz
            break
          fi
          if [[ $times_tried -ge 3 ]];then
            echo "Download scala-2.11.12.tgz failed!" && exit 1;
          fi
          times_tried=$((times_tried + 1))
          rm -rf scala-2.11.12.tgz
        done
      ) || exit 1
    fi

    if [[ ! -f "${lib_path}/ansj_seg-5.1.6.jar" ]]
    then
      ( cd "${lib_path}" && curl -O http://download.mlsql.tech/nlp/ansj_seg-5.1.6.jar ) || exit 1
    fi

    if [[ ! -f "${lib_path}/nlp-lang-1.7.8.jar" ]]
    then
      ( cd "${lib_path}" && curl -O http://download.mlsql.tech/nlp/nlp-lang-1.7.8.jar ) || exit 1
    fi

    if [[ ${SPARK_VERSION} == "2.4.3" && ! -f "${lib_path}/azure-blob_2.7-1.0-SNAPSHOT.jar" ]]
    then
      wget --no-check-certificate --no-verbose "https://download.byzer.org/byzer/misc/azure-blob_2.7-1.0-SNAPSHOT.jar" \
        --directory-prefix "${lib_path}/"
    fi

    if [[ ${SPARK_VERSION} == "3.1.1" && ! -f "${lib_path}/azure-blob_3.2-1.0-SNAPSHOT.jar" ]]
    then
      wget --no-check-certificate --no-verbose "https://download.byzer.org/byzer/misc/azure-blob_3.2-1.0-SNAPSHOT.jar" \
        --directory-prefix "${lib_path}/"
    fi

    ## if byzer-lang tar ball does not exist in dev/lib, exit
    if [[ ! -f "${lib_path}/mlsql-engine_${MLSQL_SPARK_VERSION}-${BYZER_LANG_VERSION}.tar.gz" ]]
    then
      echo "Please put Byzer-lang tar ball in dev/lib"
      exit 1
    fi


}

## Builds mlsql-api-console shade jar
function build_mlsql_api_console {
    ## Build mlsql-api-console
    "${base_dir}/dev/bin/update-console.sh" \
    && mvn -f ${mlsql_console_path}/pom.xml clean compile package -DskipTests -Pshade
    ## Check if jar file exists
    if [[ ! -f "${mlsql_console_path}/target/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar" ]]
    then
    echo "Failed to generate mlsql-api-console jar file, exit"
    exit 1
    fi
    cp ${mlsql_console_path}/target/mlsql-api-console-${MLSQL_CONSOLE_VERSION}.jar ${lib_path}/
}

## Builds byzer_notebook shade jar
function build_byzer_notebook {
    ## Build byzer-notebook
    sh "${base_dir}/dev/bin/update-byzer-notebook.sh" && \
    bash "${byzer_notebook_path}"/build/package.sh skipTar

    ## Check if jar file exists
    echo "notebook path: ""${base_dir}/byzer-notebook/dist/Byzer-Notebook-${BYZER_NOTEBOOK_VERSION}"
    if [[ ! -d "${base_dir}/byzer-notebook/dist/Byzer-Notebook-${BYZER_NOTEBOOK_VERSION}" ]]
    then
      echo "Failed to generate byzer-notebook jar file, exit"
      exit 1
    fi
    cp -r "${byzer_notebook_path}/dist/Byzer-Notebook-${BYZER_NOTEBOOK_VERSION}" "${lib_path}/"
}
