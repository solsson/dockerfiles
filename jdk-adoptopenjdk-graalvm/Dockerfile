FROM adoptopenjdk:11.0.10_9-jdk-hotspot-focal@sha256:30f365f93818de7d30c624077a5e06f06b775eb1b042c1eecf132fb2f93771f7

COPY --from=maven:3.6.3-adoptopenjdk-11@sha256:1f07812fb5bba1371fd743bbcd2053fa3324c1b7f463fe7516a646c87852c4cf \
  /usr/share/maven /usr/share/maven
RUN ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME=/usr/share/maven
ENV MAVEN_CONFIG=/root/.m2

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='ca-certificates netcat-openbsd libsnappy1v5 liblz4-1 libzstd1'; \
  buildDeps='curl gnupg dirmngr build-essential zlib1g-dev libsnappy-dev liblz4-dev libzstd-dev'; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  # Keeping build deps for native compile
  #apt-get purge -y --auto-remove $buildDeps; \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

ARG graalvm_version=21.0.0.2
ARG graalvm_variant=java11
ARG graalvm_releases=graalvm/graalvm-ce-builds
ARG graalvm_build=

RUN set -ex; \
  cd /opt; \
  curl -sLS -o graalvm.tar.gz https://github.com/${graalvm_releases}/releases/download/vm-${graalvm_version}${graalvm_build}/graalvm-ce-${graalvm_variant}-linux-amd64-${graalvm_version}.tar.gz; \
  tar xvzf graalvm.tar.gz; \
  mv graalvm-ce-${graalvm_variant}-${graalvm_version} graalvm; \
  rm graalvm.tar.gz

ENV PATH=/opt/java/openjdk/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/graalvm/bin

RUN gu install native-image
