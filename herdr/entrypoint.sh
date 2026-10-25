#!/usr/bin/env bash

set -euo pipefail

cp --update=none /etc/skel/.bashrc /etc/skel/.profile /root/

for agent in pi claude codex; do
  herdr integration install "$agent" || echo "herdr integration $agent failed" >&2
done

tailscaled --tun=userspace-networking --statedir=/var/lib/tailscale &

until tailscale status --json >/dev/null 2>&1; do sleep 0.5; done

tailscale up \
  --login-server="$TS_LOGIN_SERVER" \
  --hostname="$TS_HOSTNAME" \
  --ssh \
  --auth-key=file:/run/secrets/tailscale/authkey

# Remote clients require the server to lead its own session, and setsid hides it from tini's signals: forward TERM.
bash -lc 'exec setsid herdr server' &
trap 'kill -TERM $!' TERM
wait $! || wait $!
