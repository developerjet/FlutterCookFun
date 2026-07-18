#!/usr/bin/env bash

set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [[ "${SKIP_CONFIRM:-false}" != "true" ]]; then
  printf '\n即将执行：启动 Flutter 工程\n按回车继续，按 Ctrl+C 取消... '
  if ! IFS= read -r _; then
    printf '\n未收到确认输入，已取消执行。\n' >&2
    exit 130
  fi
fi

exec "${SCRIPT_DIR}/../shell/run_flutter.sh" "$@"
