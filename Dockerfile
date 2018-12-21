ARG DOCKER_REGISTRY=docker.io
ARG FROM_IMG_REPO=qnib
ARG FROM_IMG_NAME="uplain-init"
ARG FROM_IMG_TAG="xenial_2018-12-08.1"
ARG FROM_IMG_HASH=""
FROM ${DOCKER_REGISTRY}/${FROM_IMG_REPO}/${FROM_IMG_NAME}:${FROM_IMG_TAG}${DOCKER_IMG_HASH}

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get update \
 && apt-get install --no-install-recommends -y software-properties-common=0.96.20.7 swig=3.0.8-0ubuntu3 \
 && rm -rf /var/lib/apt/lists/*
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && add-apt-repository -y ppa:webupd8team/java \
 && apt-get update \
 && apt-get install -y --no-install-recommends oracle-java8-installer=8u191-1~webupd8~1 \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/oracle-jdk8-installer
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl=7.47.0-1ubuntu2.11 \
 && echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
 && curl https://storage.googleapis.com/bazel-apt/doc/apt-key.pub.gpg |  apt-key add - \
 && apt-get update \
 && apt-get install -y --no-install-recommends bazel=0.21.0 \
 && rm -rf /var/lib/apt/lists/*
