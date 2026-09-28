#!/usr/bin/env bash

set -euo pipefail

VERSION="v0.36.0"
REGISTRY="ghcr.io/leonardjouve"
TAG="${VERSION#v}" # Strip the leading v
IMAGE="$REGISTRY/crw:$TAG"

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

git clone -q --depth 1 --branch "$VERSION" https://github.com/fastcrw/crw "$tmp/crw"

docker buildx build \
  --platform linux/amd64 \
  --build-arg CARGO_PKGS="-p crw-server --features cdp,impersonated" \
  --build-arg CARGO_BUILD_JOBS="${CARGO_BUILD_JOBS:-6}" \
  -t "$IMAGE" \
  -t "$REGISTRY/crw:latest" \
  --push \
  "$tmp/crw"

echo "built and pushed: $IMAGE"

