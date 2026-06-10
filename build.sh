#!/bin/bash

set -euo pipefail

IMAGE=glove80-zmk-config-docker
BRANCH="${1:-v25.11}"

docker build -t "$IMAGE" .
docker run --rm -v "$PWD:/config" -e UID="$(id -u)" -e GID="$(id -g)" -e BRANCH="$BRANCH" "$IMAGE"
