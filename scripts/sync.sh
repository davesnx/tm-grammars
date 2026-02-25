#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
SOURCES="$ROOT_DIR/sources.json"
VENDOR_DIR="$ROOT_DIR/vendor"

if ! command -v jq &> /dev/null; then
  echo "error: jq is required but not installed" >&2
  exit 1
fi

mkdir -p "$VENDOR_DIR"

lang_ids=$(jq -r 'keys[]' "$SOURCES")
total=$(echo "$lang_ids" | wc -l | tr -d ' ')
count=0

for lang_id in $lang_ids; do
  count=$((count + 1))
  repo=$(jq -r --arg k "$lang_id" '.[$k].repo' "$SOURCES")
  path=$(jq -r --arg k "$lang_id" '.[$k].path' "$SOURCES")
  commit=$(jq -r --arg k "$lang_id" '.[$k].commit' "$SOURCES")

  url="https://raw.githubusercontent.com/${repo}/${commit}/${path}"
  dest="$VENDOR_DIR/${lang_id}.json"

  printf "[%d/%d] %s ... " "$count" "$total" "$lang_id"

  if curl -sfL "$url" -o "$dest"; then
    if jq empty "$dest" 2>/dev/null; then
      echo "ok"
    else
      echo "INVALID JSON"
      rm -f "$dest"
      exit 1
    fi
  else
    echo "FAILED (url: $url)"
    exit 1
  fi
done

echo ""
echo "Synced $total grammars to vendor/"
