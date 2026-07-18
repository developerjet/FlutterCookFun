#!/usr/bin/env bash

set -Eeuo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

enter_project_root
require_command flutter

MODE="${MODE:-debug}"
DEVICE_ID="${DEVICE_ID:-}"
validate_build_mode "${MODE}"

run_flutter_pub_get

FLUTTER_ARGS=(run "--${MODE}")
append_common_flutter_args

if [[ -n "${DEVICE_ID}" ]]; then
  FLUTTER_ARGS+=(--device-id "${DEVICE_ID}")
fi

log "启动 Flutter 工程：flutter ${FLUTTER_ARGS[*]} $*"
flutter "${FLUTTER_ARGS[@]}" "$@"
