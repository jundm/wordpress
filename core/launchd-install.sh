#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
LABEL="${LABEL:-com.lkkkorea.wp-compose}"
AGENT_DIR="${AGENT_DIR:-$HOME/Library/LaunchAgents}"
PLIST_PATH="${PLIST_PATH:-$AGENT_DIR/${LABEL}.plist}"
AUTO_START_SCRIPT="${AUTO_START_SCRIPT:-$ROOT_DIR/core/auto-start.sh}"
PATH_VALUE="${PATH_VALUE:-/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin}"
STDOUT_PATH="${STDOUT_PATH:-/tmp/wp-compose.out}"
STDERR_PATH="${STDERR_PATH:-/tmp/wp-compose.err}"

cmd="${1:-install}"

install_agent() {
  mkdir -p "${AGENT_DIR}"
  cat > "${PLIST_PATH}" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key><string>${LABEL}</string>
  <key>ProgramArguments</key>
  <array>
    <string>${AUTO_START_SCRIPT}</string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>PATH</key><string>${PATH_VALUE}</string>
  </dict>
  <key>RunAtLoad</key><true/>
  <key>StandardOutPath</key><string>${STDOUT_PATH}</string>
  <key>StandardErrorPath</key><string>${STDERR_PATH}</string>
</dict>
</plist>
EOF
  chmod 644 "${PLIST_PATH}"
  launchctl unload "${PLIST_PATH}" >/dev/null 2>&1 || true
  launchctl load "${PLIST_PATH}"
  echo "Installed ${PLIST_PATH}"
}

uninstall_agent() {
  launchctl unload "${PLIST_PATH}" >/dev/null 2>&1 || true
  rm -f "${PLIST_PATH}"
  echo "Removed ${PLIST_PATH}"
}

status_agent() {
  launchctl list | grep -F "${LABEL}" || true
}

case "${cmd}" in
  install) install_agent ;;
  uninstall) uninstall_agent ;;
  status) status_agent ;;
  *)
    echo "Usage: $0 [install|uninstall|status]" >&2
    exit 2
    ;;
esac
