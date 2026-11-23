#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <output-file>" >&2
  exit 1
fi

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
output_file="$1"

entries() {
  jq -r '
    to_entries[]
    | .key as $id
    | .value as $v
    | "\($id) | \($v.originalSource // $v.repo) | \($v.license // "NOASSERTION") | \($v.licenseUrl // "n/a")"
  ' "$1"
}

{
  cat <<'HEADER'
Third-Party Licenses
====================

This project vendors TextMate grammar and theme files from external sources.
The source and license metadata below is generated from `sources.json`
(grammars) and `themes.json` (themes). `license` uses SPDX identifiers when
known. `NOASSERTION` means no explicit license assertion was available from
upstream metadata.

For the full license terms of each grammar or theme, follow the listed license URL.

Intermediary Distribution
------------------------

Repository:  https://github.com/shikijs/textmate-grammars-themes
Packages:    packages/tm-grammars, packages/tm-themes
License:     MIT
License URL: https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/main/LICENSE

Per-Grammar Metadata
--------------------

Format:
grammar-id | original-source | license | license-url

HEADER
  entries "$ROOT_DIR/sources.json"
  cat <<'HEADER'

Per-Theme Metadata
------------------

Format:
theme-id | original-source | license | license-url

HEADER
  entries "$ROOT_DIR/themes.json"
} > "$output_file"
