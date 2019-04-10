ARG DOCKER_REGISTRY=docker.io
ARG FROM_IMG_REPO=qnib
ARG FROM_IMG_NAME="uplain-pip3"
ARG FROM_IMG_TAG="2018-12-23.1"
ARG FROM_IMG_HASH=""
ARG BAZEL_VER=0.19.2
FROM ${DOCKER_REGISTRY}/${FROM_IMG_REPO}/${FROM_IMG_NAME}:${FROM_IMG_TAG}${DOCKER_IMG_HASH}

ENV DEBIAN_FRONTEND=noninteractive \
    DEBCONF_NONINTERACTIVE_SEEN=true
ARG BAZEL_VER

RUN apt-get update \
 && apt-get install --no-install-recommends -y software-properties-common swig gpg-agent \
 && rm -rf /var/lib/apt/lists/*
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
 && add-apt-repository -y ppa:webupd8team/java \
 && apt-get update \
 && apt-get install -y --no-install-recommends oracle-java8-installer \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /var/cache/oracle-jdk8-installer
RUN apt-get update \
 && apt-get install -y --no-install-recommends curl \
 && echo "deb [arch=amd64] http://storage.googleapis.com/bazel-apt stable jdk1.8" | tee /etc/apt/sources.list.d/bazel.list \
 && curl https://storage.googleapis.com/bazel-apt/doc/apt-key.pub.gpg |  apt-key add - \
 && rm -rf /var/lib/apt/lists/*
RUN apt-get update \
 && apt-get install -y pkg-config zip g++ zlib1g-dev unzip \
 && rm -rf /var/lib/apt/lists/*
RUN wget -qO /opt/bazel-installer-linux-x86_64.sh https://github.com/bazelbuild/bazel/releases/download/${BAZEL_VER}/bazel-${BAZEL_VER}-installer-linux-x86_64.sh \
 && chmod +x /opt/bazel-installer-linux-x86_64.sh \
 && bash /opt/bazel-installer-linux-x86_64.sh \
 && rm -f /opt/bazel-installer-linux-x86_64.sh
