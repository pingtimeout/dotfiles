#!/usr/bin/env bash

set -Eeuo pipefail

DOCKER_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_REPOSITORY="${IMAGE_REPOSITORY:-pingtimeoutfr/dotfiles}"

podman build --pull \
  --tag "${IMAGE_REPOSITORY}:latest" \
  "${DOCKER_DIR}"
podman push "${IMAGE_REPOSITORY}:latest"
