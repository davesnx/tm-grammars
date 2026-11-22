#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 3 ]; then
  echo "usage: $0 <README.mld> <sources.json> <themes.json>" >&2
  exit 1
fi

template="$1"
sources_json="$2"
themes_json="$3"

ids() {
  jq -r 'keys[]' "$1" | sed 's/^/`/' | sed 's/$/`/' | sed '$!s/$/,/' | tr '\n' ' ' | sed 's/[[:space:]]*$//' | sed 's/[&|]/\\&/g'
}

sed \
  -e "s|@@SUPPORTED_LANGUAGE_IDS@@|$(ids "$sources_json")|" \
  -e "s|@@SUPPORTED_THEME_IDS@@|$(ids "$themes_json")|" \
  -e 's/^{0 \(.*\)}$/# \1/' \
  -e 's/^{1 \(.*\)}$/## \1/' \
  -e 's/^{2 \(.*\)}$/### \1/' \
  -e 's/^{@\([A-Za-z0-9_+-]*\)\[$/```\1/' \
  -e 's/^{@\[$/```/' \
  -e 's/^]}$/```/' \
  "$template"
