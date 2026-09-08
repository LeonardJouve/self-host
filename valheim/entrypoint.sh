#!/bin/bash
exec /opt/valheim/valheim_server.x86_64 \
    -nographics -batchmode \
    -name "${SERVER_NAME}" \
    -password "${SERVER_PASSWORD}" \
    -world "${WORLD}" \
    -port "${PORT}" \
    -public "${PUBLIC}" \
    -savedir /data
