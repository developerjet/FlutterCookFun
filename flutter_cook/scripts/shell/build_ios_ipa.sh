#!/usr/bin/env bash

set -Eeuo pipefail

source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/common.sh"

enter_project_root
require_command flutter
require_command xcodebuild

[[ "$(uname -s)" == "Darwin" ]] || fail "iOS IPA 只能在 macOS 环境构建"
[[ -d ios ]] || fail "缺少 ios 工程目录"

MODE="${MODE:-release}"
EXPORT_METHOD="${EXPORT_METHOD:-}"
EXPORT_OPTIONS_PLIST="${EXPORT_OPTIONS_PLIST:-}"
NO_CODESIGN="${NO_CODESIGN:-false}"
SKIP_POD_INSTALL="${SKIP_POD_INSTALL:-false}"
validate_build_mode "${MODE}"

run_flutter_clean_if_needed
run_flutter_pub_get

if [[ "${SKIP_POD_INSTALL}" != "true" && -f ios/Podfile ]]; then
  require_command pod
  log "同步 iOS CocoaPods 依赖"
  (cd ios && pod install)
fi

FLUTTER_ARGS=(build ipa "--${MODE}")
append_common_flutter_args
append_build_version_args

if [[ "${NO_CODESIGN}" == "true" ]]; then
  FLUTTER_ARGS+=(--no-codesign)
fi

if [[ -n "${EXPORT_METHOD}" ]]; then
  FLUTTER_ARGS+=(--export-method "${EXPORT_METHOD}")
fi

if [[ -n "${EXPORT_OPTIONS_PLIST}" ]]; then
  [[ -f "${EXPORT_OPTIONS_PLIST}" ]] || fail "ExportOptions.plist 不存在：${EXPORT_OPTIONS_PLIST}"
  FLUTTER_ARGS+=(--export-options-plist "${EXPORT_OPTIONS_PLIST}")
elif [[ -f ios/ExportOptions.plist ]]; then
  FLUTTER_ARGS+=(--export-options-plist ios/ExportOptions.plist)
fi

log "构建 iOS IPA：flutter ${FLUTTER_ARGS[*]} $*"
flutter "${FLUTTER_ARGS[@]}" "$@"

log "IPA 输出目录：${PROJECT_ROOT}/build/ios/ipa"
find "${PROJECT_ROOT}/build/ios/ipa" -maxdepth 1 -type f -name '*.ipa' -print 2>/dev/null || true
