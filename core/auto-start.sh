#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
WAIT_SECONDS="${WAIT_SECONDS:-120}"
SLEEP_SECONDS="${SLEEP_SECONDS:-2}"

deadline=$(( $(date +%s) + WAIT_SECONDS ))
until docker info >/dev/null 2>&1; do
  if [[ $(date +%s) -ge "${deadline}" ]]; then
    echo "Docker not ready after ${WAIT_SECONDS}s" >&2
    exit 1
  fi
  sleep "${SLEEP_SECONDS}"
done

cd "${ROOT_DIR}"
docker compose up -d
