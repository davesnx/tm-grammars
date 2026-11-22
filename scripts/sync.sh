#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/kind.sh"

if ! command -v jq &> /dev/null; then
  echo "error: jq is required but not installed" >&2
  exit 1
fi

mkdir -p "$vendor_dir"
rm -f "$vendor_dir"/*.json

ids=$(jq -r 'keys[]' "$sources")
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
    case "$package:$id" in
      tm-grammars:dune)
        jq '.fileTypes |= ((. + ["dune-project", "dune-workspace"]) | unique)' "$dest" > "$dest.tmp"
        mv "$dest.tmp" "$dest"
        ;;
      tm-grammars:ocaml)
        jq '.fileTypes |= ((. + ["mli", "eliomi"]) | unique)' "$dest" > "$dest.tmp"
        mv "$dest.tmp" "$dest"
        ;;
    esac

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
echo "Synced $total $1 to $(basename "$vendor_dir")/"
