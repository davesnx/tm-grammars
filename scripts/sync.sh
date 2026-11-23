#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/kind.sh"
kind="$1"
shift
patches_dir="$ROOT_DIR/scripts/patches"

if ! command -v jq &> /dev/null; then
  echo "error: jq is required but not installed" >&2
  exit 1
fi

mkdir -p "$vendor_dir"

if [ "$#" -gt 0 ]; then
  for id in "$@"; do
    if ! jq -e --arg k "$id" 'has($k)' "$sources" > /dev/null; then
      echo "error: unknown $label id: $id" >&2
      exit 1
    fi
  done
  ids=$(printf '%s\n' "$@")
else
  rm -f "$vendor_dir"/*.json
  ids=$(jq -r 'keys[]' "$sources")
fi
total=$(echo "$ids" | wc -l | tr -d ' ')
count=0

for id in $ids; do
  count=$((count + 1))
  repo=$(jq -r --arg k "$id" '.[$k].repo' "$sources")
  path=$(jq -r --arg k "$id" '.[$k].path' "$sources")
  commit=$(jq -r --arg k "$id" '.[$k].commit' "$sources")

  url="https://raw.githubusercontent.com/${repo}/${commit}/${path}"
  dest="$vendor_dir/${id}.json"

  printf "[%d/%d] %s ... " "$count" "$total" "$id"

  if curl -sfL "$url" -o "$dest"; then
    patch="$patches_dir/${id}.jq"
    if [ "$package" = "tm-grammars" ] && [ -f "$patch" ]; then
      jq -f "$patch" "$dest" > "$dest.tmp"
      mv "$dest.tmp" "$dest"
    fi

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
echo "Synced $total $kind to $(basename "$vendor_dir")/"
