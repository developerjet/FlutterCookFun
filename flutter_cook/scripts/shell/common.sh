#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROJECT_ROOT="$(cd "${SCRIPTS_DIR}/.." && pwd)"

log() {
  printf '[flutter_cook] %s\n' "$*"
}

fail() {
  printf '[flutter_cook][error] %s\n' "$*" >&2
  exit 1
}

require_command() {
  local command_name="$1"
  command -v "${command_name}" >/dev/null 2>&1 || fail "未找到依赖命令：${command_name}"
}

enter_project_root() {
  cd "${PROJECT_ROOT}"
}

validate_build_mode() {
  local mode="$1"
  case "${mode}" in
    debug | profile | release) ;;
    *) fail "MODE 仅支持 debug、profile、release，当前值：${mode}" ;;
  esac
}

append_common_flutter_args() {
  local target="${TARGET:-lib/main.dart}"

  [[ -f "${target}" ]] || fail "入口文件不存在：${target}"
  FLUTTER_ARGS+=(--target "${target}")

  if [[ -n "${FLAVOR:-}" ]]; then
    FLUTTER_ARGS+=(--flavor "${FLAVOR}")
  fi

  append_dart_defines
}

append_build_version_args() {
  if [[ -n "${BUILD_NAME:-}" ]]; then
    FLUTTER_ARGS+=(--build-name "${BUILD_NAME}")
  fi

  if [[ -n "${BUILD_NUMBER:-}" ]]; then
    FLUTTER_ARGS+=(--build-number "${BUILD_NUMBER}")
  fi
}

append_dart_defines() {
  if [[ -z "${DART_DEFINES:-}" ]]; then
    return
  fi

  local define_entry
  local old_ifs="${IFS}"
  IFS=';'
  for define_entry in ${DART_DEFINES}; do
    [[ -n "${define_entry}" ]] || continue
    FLUTTER_ARGS+=(--dart-define "${define_entry}")
  done
  IFS="${old_ifs}"
}

run_flutter_pub_get() {
  if [[ "${PUB_GET:-true}" != "true" ]]; then
    log "跳过 flutter pub get"
    return
  fi

  require_command flutter
  log "同步 Flutter 依赖"
  flutter pub get
}

run_flutter_clean_if_needed() {
  if [[ "${CLEAN:-false}" != "true" ]]; then
    return
  fi

  require_command flutter
  log "清理 Flutter 构建缓存"
  flutter clean
}
