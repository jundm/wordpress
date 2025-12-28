#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
ENV_FILE="$ROOT_DIR/.env.deploy"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing .env.deploy. Copy .env.deploy.example and fill values." >&2
  exit 1
fi

# shellcheck disable=SC1090
source "$ENV_FILE"

: "${DEPLOY_HOST:?}"
: "${DEPLOY_USER:?}"
: "${DEPLOY_PATH:?}"
: "${DEPLOY_BRANCH:?}"

ssh "${DEPLOY_USER}@${DEPLOY_HOST}" bash -lc "'
  set -euo pipefail
  cd "${DEPLOY_PATH}"
  git fetch --all
  git checkout "${DEPLOY_BRANCH}"
  git pull --ff-only origin "${DEPLOY_BRANCH}"
  docker compose pull
  docker compose up -d
'"
