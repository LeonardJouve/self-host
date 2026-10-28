ARG TAILSCALE_VERSION=v1.104.2
FROM tailscale/tailscale:${TAILSCALE_VERSION} AS tailscale

FROM node:24-trixie-slim

RUN apt-get update \
 && apt-get install -y --no-install-recommends bash bash-completion ca-certificates curl git less nano procps ripgrep tini wget libicu76 gcc g++ libc6-dev make \
 && rm -rf /var/lib/apt/lists/*

RUN curl -fsSL https://dot.net/v1/dotnet-install.sh \
 | bash -s -- --channel 10.0 --install-dir /usr/share/dotnet

ARG GO_VERSION=1.27.3
RUN curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" | tar -C /usr/local -xz

RUN npm install -g "@anthropic-ai/claude-code" "@openai/codex" "@earendil-works/pi-coding-agent" \
 && npm cache clean --force

COPY --from=tailscale /usr/local/bin/tailscaled /usr/local/bin/tailscale /usr/local/bin/
RUN curl -fsSL https://herdr.dev/install.sh | HERDR_INSTALL_DIR=/usr/local/bin sh

ENV DOTNET_ROOT=/usr/share/dotnet \
    DOTNET_CLI_TELEMETRY_OPTOUT=1 \
    PATH="$PATH:/usr/local/go/bin:/root/go/bin:/usr/share/dotnet:/root/.dotnet/tools" \
    SHELL=/bin/bash

COPY profile.sh /etc/profile.d/herdr.sh
COPY --chmod=755 entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/usr/local/bin/entrypoint.sh"]
