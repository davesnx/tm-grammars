#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <README.mld>" >&2
  exit 1
fi

template="$1"

ids="$({
  ls -1 packages \
    | sed -n 's/^tm-grammar-\(.*\)$/`\1`/p' \
    | sed '/^`s-all`$/d' \
    | sed '$!s/$/,/' \
    | tr '\n' ' '
} | sed 's/[[:space:]]*$//')"

escaped_ids="$(printf '%s\n' "$ids" | sed 's/[&|]/\\&/g')"

sed \
  -e "s|@@SUPPORTED_LANGUAGE_IDS@@|$escaped_ids|" \
  -e 's/^{0 \(.*\)}$/# \1/' \
  -e 's/^{1 \(.*\)}$/## \1/' \
  -e 's/^{\[$/```/' \
  -e 's/^]}$/```/' \
  "$template"
