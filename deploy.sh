#!/usr/bin/env bash
# 一键重新部署：改完 data.js 后执行 ./deploy.sh
set -euo pipefail
cd "$(dirname "$0")"

NODE_BIN="${NODE_BIN:-node}"
if command -v node >/dev/null 2>&1; then NODE_BIN=node; fi

# 1) 语法检查：data.js 写错会直接在这里报出来
"$NODE_BIN" --check data.js
echo "✓ data.js 语法 OK"

# 2) 部署（域名固定，覆盖更新）
if [ -z "${SURGE_TOKEN:-}" ]; then
  echo "✗ 缺少 SURGE_TOKEN。先执行："
  echo "  export SURGE_LOGIN='你的 surge 邮箱'"
  echo "  export SURGE_TOKEN='你的 surge token'"
  exit 1
fi

npx --yes surge ./ 100-memory-stars.surge.sh
echo "✓ 已部署：https://100-memory-stars.surge.sh"
