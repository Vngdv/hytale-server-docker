FROM eclipse-temurin:25-jre

LABEL maintainer="vngdv@andrerm.com"
LABEL description="Hytale Dedicated Server"

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    curl jq unzip procps ca-certificates gosu && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN groupadd -g 1001 hytale && \
    useradd -u 1001 -g hytale -m -s /bin/bash hytale

WORKDIR /hytale-server

COPY --chown=hytale:hytale scripts/ /scripts/
COPY --chown=hytale:hytale . /hytale-server

RUN chmod -R 750 /hytale-server && \
    chmod +x /scripts/*.sh

EXPOSE 5520/udp

ENTRYPOINT ["/scripts/entrypoint.sh"]

HEALTHCHECK --interval=30s --timeout=3s --start-period=60s --retries=3 \
    CMD pgrep -f HytaleServer.jar || exit 1