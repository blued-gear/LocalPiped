#!/bin/bash

set -e

if [[ $PWD != */pipedproxy ]]; then
  echo 'this script must be called from the directory containing it' >&2
  exit 1
fi

if which podman >/dev/null 2>&1; then
  container_mng="podman"
elif which docker >/dev/null 2>&1; then
  container_mng="docker"
else
  echo "needs either podman or docker"
  exit 1
fi

IMAGE="docker.io/1337kavin/piped-proxy:latest"
readonly IMAGE

container_id=$($container_mng create "$IMAGE")
$container_mng cp "$container_id:/app/piped-proxy" "./piped-proxy"
$container_mng rm "$container_id"

if [[ "$PROXY_KEEP_IMG" == "" ]]; then
  $container_mng image rm "$IMAGE"
fi

echo 'done'
