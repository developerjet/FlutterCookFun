#!/usr/bin/env bash

set -Eeuo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

enter_project_root
require_command flutter

MODE="${MODE:-release}"
SPLIT_PER_ABI="${SPLIT_PER_ABI:-false}"
validate_build_mode "${MODE}"

run_flutter_clean_if_needed
run_flutter_pub_get

FLUTTER_ARGS=(build apk "--${MODE}")
append_common_flutter_args
append_build_version_args

if [[ "${SPLIT_PER_ABI}" == "true" ]]; then
  FLUTTER_ARGS+=(--split-per-abi)
fi

log "构建 Android APK：flutter ${FLUTTER_ARGS[*]} $*"
flutter "${FLUTTER_ARGS[@]}" "$@"

log "APK 输出目录：${PROJECT_ROOT}/build/app/outputs/flutter-apk"
find "${PROJECT_ROOT}/build/app/outputs/flutter-apk" -maxdepth 1 -type f -name '*.apk' -print 2>/dev/null || true
