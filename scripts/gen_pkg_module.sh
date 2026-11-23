#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/kind.sh"

while IFS= read -r id; do
  id="${id%$'\r'}"
  json_file="$vendor_dir/$id.json"
  if [ ! -f "$json_file" ]; then
    echo "error: $(basename "$sources") lists $id but $json_file is missing" >&2
    exit 1
  fi
  module="$packages_dir/$id/$(module_name "$id")"

  content="$(<"$json_file")"
  delim="json"
  while [[ "$content" == *"|${delim}}"* ]]; do
    delim="${delim}_"
  done

  cat > "$module.ml" <<OCAML
let ${id_value} = "${id}"
let json = {${delim}|${content}|${delim}}
OCAML

  cat > "$module.mli" <<OCAML
val ${id_value} : string
val json : string
OCAML

  format_ocaml "$module.ml" "$module.mli"
done < <(jq -r 'keys[]' "$sources")
