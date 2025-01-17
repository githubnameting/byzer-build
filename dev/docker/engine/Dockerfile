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

# The Dockerfile for Byzer-lang K8S image

FROM ubuntu:20.04 AS ubuntu-jdk-conda

ARG JDK_MAJOR=14
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV JAVA_HOME=/work/jdk-14
ENV PATH=$PATH:${JAVA_HOME}/bin

RUN set -ex \
   && apt-get update \
   && apt-get install -y locales tini wget \
   && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
   && rm -rf /var/lib/apt/lists/*

## Openjdk-14
RUN mkdir /work
ADD lib/openjdk-14_linux-x64_bin.tar.gz /work/

## Install conda
COPY lib/miniconda.sh /work/
RUN /bin/bash /work/miniconda.sh -b -p /opt/conda && \
    rm /work/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /etc/profile && \
    echo "conda activate base" >> /etc/profile && \
    . /etc/profile

## Add aliyun pip mirror
## Install python packages
RUN mkdir ~/.pip && \
    echo "[global]\n trusted-host = mirrors.aliyun.com\n index-url = https://mirrors.aliyun.com/pypi/simple" > ~/.pip/pip.conf && \
    . /etc/profile && \
    pip install --upgrade pip && \
    pip install --no-cache-dir \
      Cython numpy pandas scikit-learn plotly ray[default]==1.3.0 \
      watchdog requests click uuid sfcli \
      aiohttp psutil setproctitle grpcio xlsxwriter \
      watchdog requests click uuid sfcli pyjava>=0.2.8.8 pyarrow

FROM ubuntu-jdk-conda AS mlsql-engine

ARG SPARK_VERSION=3.1.1
ARG MLSQL_SPARK_VERSION=3.0
ARG BYZER_LANG_VERSION=2.1.0-SNAPSHOT
ARG JUICE_JAR_NAME=juicefs-hadoop-0.15.2-linux-amd64.jar
ARG SCALA_BINARY_VERSION=2.12
ARG AZURE_BLOB_NAME=azure-blob_3.2-1.0-SNAPSHOT.jar

## Setup environment variables
ENV SPARK_HOME /work/spark-${SPARK_VERSION}-bin-hadoop3.2
ENV BASE_DIR /home/deploy
ENV MLSQL_HOME ${BASE_DIR}/mlsql
ENV PATH=$PATH:${MLSQL_HOME}/bin:${SPARK_HOME}/sbin:${SPARK_HOME}/bin:/opt/conda/bin

## Creates directories
RUN mkdir -p /work/logs
RUN mkdir -p /work/user

## Spark
ADD lib/spark-${SPARK_VERSION}-bin-hadoop3.2.tgz /work
COPY docker/mlsql-sandbox/conf/log4j.properties ${SPARK_HOME}/conf/

## copy jars to Spark/home
COPY lib/${JUICE_JAR_NAME} \
  lib/ansj_seg-5.1.6.jar \
  lib/nlp-lang-1.7.8.jar \
  ${SPARK_HOME}/jars/

WORKDIR ${BASE_DIR}

## mlsql
ADD lib/"mlsql-engine_${MLSQL_SPARK_VERSION}-${BYZER_LANG_VERSION}.tar.gz" ${BASE_DIR}/
RUN mv "mlsql-engine_${MLSQL_SPARK_VERSION}-${BYZER_LANG_VERSION}" mlsql \
    && mkdir -p ${BASE_DIR}/mlsql/logs

##  auxiliary jars
COPY lib/ansj_seg-5.1.6.jar \
  lib/nlp-lang-1.7.8.jar \
  lib/${AZURE_BLOB_NAME} \
  lib/mlsql-assert-${MLSQL_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-excel-${MLSQL_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-ext-ets-${MLSQL_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-shell-${MLSQL_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/mlsql-mllib-${MLSQL_SPARK_VERSION}_${SCALA_BINARY_VERSION}-0.1.0-SNAPSHOT.jar \
  lib/${JUICE_JAR_NAME} ${MLSQL_HOME}/libs/

COPY docker/engine/start-local.sh ${MLSQL_HOME}/bin/
COPY docker/engine/entrypoint.sh ${BASE_DIR}/
ENTRYPOINT [ "/home/deploy/entrypoint.sh" ]
