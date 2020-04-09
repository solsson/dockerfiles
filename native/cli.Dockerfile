FROM ubuntu:20.04@sha256:1515a62dc73021e2e7666a31e878ef3b4daddc500c3d031b35130ac05067abc0

WORKDIR /usr/local
COPY --from=solsson/kafka:native-kafka-topics /usr/local/bin/* /usr/local/bin/

RUN set -ex; \
  export DEBIAN_FRONTEND=noninteractive; \
  runDeps='ca-certificates netcat-openbsd libsnappy1v5 liblz4-1 libzstd1 kafkacat jq'; \
  apt-get update && apt-get install -y $runDeps $buildDeps --no-install-recommends; \
  \
  rm -rf /var/lib/apt/lists; \
  rm -rf /var/log/dpkg.log /var/log/alternatives.log /var/log/apt /root/.gnupg

RUN ln -s /usr/local/bin/kafka-topics.sh /usr/local/bin/kafka-topics

# Should be identical to kafka-nonroot's user
RUN useradd --create-home --home-dir /home/nonroot --uid 65532 --gid 65534 -c nonroot -s /usr/sbin/nologin nonroot
USER nonroot:nogroup

ENTRYPOINT [ "ls", "-l", "/usr/local/bin" ]
