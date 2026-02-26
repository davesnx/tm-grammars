#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <README.mld> <sources.json>" >&2
  exit 1
fi

template="$1"
sources_json="$2"

ids="$(jq -r 'keys[]' "$sources_json" | sed 's/^/`/' | sed 's/$/`/' | sed '$!s/$/,/' | tr '\n' ' ' | sed 's/[[:space:]]*$//')"

escaped_ids="$(printf '%s\n' "$ids" | sed 's/[&|]/\\&/g')"

sed \
  -e "s|@@SUPPORTED_LANGUAGE_IDS@@|$escaped_ids|" \
  -e 's/^{0 \(.*\)}$/# \1/' \
  -e 's/^{1 \(.*\)}$/## \1/' \
  -e 's/^{@\([A-Za-z0-9_+-]*\)\[$/```\1/' \
  -e 's/^{@\[$/```/' \
  -e 's/^]}$/```/' \
  "$template"
