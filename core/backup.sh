#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
BACKUP_ROOT="${BACKUP_ROOT:-/Volumes/c/dev/wordpress_backup}"
BACKUP_DB_DIR="${BACKUP_ROOT}/db"
BACKUP_WP_DIR="${BACKUP_ROOT}/wp-content"
RETENTION_DAYS="${RETENTION_DAYS:-56}"

DATE="$(date +%F)"
DB_FILE="${BACKUP_DB_DIR}/wordpress_${DATE}.sql"
WP_DIR="${BACKUP_WP_DIR}/${DATE}"

mkdir -p "${BACKUP_DB_DIR}" "${BACKUP_WP_DIR}"

cd "${ROOT_DIR}"

docker compose exec -T db sh -lc 'mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" wordpress' > "${DB_FILE}"
rsync -a "${ROOT_DIR}/volumes/wp_data/wp-content/" "${WP_DIR}/"

find "${BACKUP_DB_DIR}" -type f -name "*.sql" -mtime +"${RETENTION_DAYS}" -delete
find "${BACKUP_WP_DIR}" -mindepth 1 -maxdepth 1 -type d -mtime +"${RETENTION_DAYS}" -exec rm -rf {} +
