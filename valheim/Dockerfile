FROM ubuntu:22.04 AS build
ARG DEBIAN_FRONTEND=noninteractive
ARG STEAM_APP_ID=896660
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl libc6-i386 \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m steam \
    && mkdir -p /opt/steamcmd \
    && curl -fsSL https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz \
       | tar xz -C /opt/steamcmd \
    && chown -R steam /opt/steamcmd
RUN mkdir -p /home/steam/valheim-dedicated \
    && chown steam /home/steam/valheim-dedicated \
    && su - steam -c '/opt/steamcmd/steamcmd.sh +login anonymous +quit' >/dev/null \
    && su - steam -c "/opt/steamcmd/steamcmd.sh +force_install_dir /home/steam/valheim-dedicated +login anonymous +app_update ${STEAM_APP_ID} validate +quit"

FROM ubuntu:22.04
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       libatomic1 libpulse0 libgssapi-krb5-2 ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && useradd -m -u 1000 steam \
    && mkdir -p /data \
    && chown steam /data
COPY --from=build --chown=steam /home/steam/valheim-dedicated /opt/valheim
RUN mkdir -p /home/steam/.steam/sdk64 \
    && ln -s /opt/valheim/linux64/steamclient.so /home/steam/.steam/sdk64/steamclient.so
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENV SERVER_NAME="Valheim Docker Server" \
    WORLD="Dedicated" \
    PORT=2456 \
    PUBLIC=1
VOLUME /data
EXPOSE 2456-2457/tcp 2456-2457/udp
USER steam
WORKDIR /opt/valheim
STOPSIGNAL SIGINT
ENTRYPOINT ["/entrypoint.sh"]
