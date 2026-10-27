#!/usr/bin/env bash
# 一键重新部署：改完 data.js 后执行 ./deploy.sh
#   ./deploy.sh         → 推到 GitHub Pages（当前线上方式，约 1 分钟生效）
#   ./deploy.sh surge   → 推到 Surge（备用，需要已配置 SURGE_TOKEN）
set -euo pipefail
cd "$(dirname "$0")"

# 1) 语法检查：data.js 写错会直接在这里报出来
node --check data.js
echo "✓ data.js 语法 OK"

if [ "${1:-}" = "surge" ]; then
  if [ -z "${SURGE_TOKEN:-}" ]; then
    echo "✗ 缺少 SURGE_TOKEN：export SURGE_LOGIN=... SURGE_TOKEN=..."
    exit 1
  fi
  npx --yes surge ./ 100-memory-stars.surge.sh
  echo "✓ 已部署到 https://100-memory-stars.surge.sh"
  exit 0
fi

# 2) 默认：提交并推送到 GitHub Pages
git add -A
git commit -m "update: $(date '+%Y-%m-%d %H:%M')" || echo "（没有内容变化）"
git push origin main
echo "✓ 已推送，GitHub Pages 约 1 分钟内生效：https://yokim99.github.io/memory-stars/"
