#!/usr/bin/env bash

set -Eeuo pipefail

DOCKER_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
IMAGE_REPOSITORY="${IMAGE_REPOSITORY:-pingtimeoutfr/dotfiles}"
DATE_TAG="$(date +%F)"

podman build --pull \
  --tag "${IMAGE_REPOSITORY}:${DATE_TAG}" \
  --tag "${IMAGE_REPOSITORY}:latest" \
  "${DOCKER_DIR}"
podman push "${IMAGE_REPOSITORY}:${DATE_TAG}"
podman push "${IMAGE_REPOSITORY}:latest"
