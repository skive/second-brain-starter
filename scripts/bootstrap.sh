#!/usr/bin/env bash
# Разворачивает базу знаний из second-brain-starter в указанную папку.
# Использование: ./bootstrap.sh ~/Documents/KB
set -euo pipefail

TARGET="${1:-}"
if [ -z "$TARGET" ]; then
  echo "Укажите папку назначения: ./bootstrap.sh ~/Documents/KB" >&2
  exit 1
fi
if [ -d "$TARGET" ] && [ -n "$(ls -A "$TARGET" 2>/dev/null)" ]; then
  echo "Папка $TARGET не пуста. Остановлено, чтобы ничего не затереть." >&2
  exit 1
fi

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

git clone --depth 1 https://github.com/skive/second-brain-starter "$TMP" >/dev/null 2>&1
mkdir -p "$TARGET"
cp -R "$TMP"/vault/. "$TARGET"/
find "$TARGET" -name .gitkeep -delete

git -C "$TARGET" init -q -b main 2>/dev/null || git -C "$TARGET" init -q
git -C "$TARGET" add -A
git -C "$TARGET" commit -q -m "База развёрнута из second-brain-starter"

echo "Готово: $TARGET"
echo "Дальше откройте эту папку агентом и скажите: «Настрой мою базу знаний»."
