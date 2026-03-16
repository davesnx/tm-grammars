#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <sources.json> <output-file>" >&2
  exit 1
fi

sources_json="$1"
output_file="$2"

{
  cat <<'EOF'
Third-Party Licenses
====================

This project vendors TextMate grammar files from external sources.
The source and license metadata below is generated from `sources.json`.
`license` uses SPDX identifiers when known. `NOASSERTION` means no explicit
license assertion was available from upstream metadata.

For the full license terms of each grammar, follow the listed license URL.

Intermediary Distribution
------------------------

Repository:  https://github.com/shikijs/textmate-grammars-themes
Package:     packages/tm-grammars
License:     MIT
License URL: https://raw.githubusercontent.com/shikijs/textmate-grammars-themes/main/LICENSE

Per-Grammar Metadata
--------------------

Format:
grammar-id | original-source | license | license-url

EOF

  jq -r '
    to_entries[]
    | .key as $id
    | .value as $v
    | "\($id) | \($v.originalSource // $v.repo) | \($v.license // "NOASSERTION") | \($v.licenseUrl // "n/a")"
  ' "$sources_json"
} > "$output_file"
