#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/kind.sh"

for id in $(jq -r 'keys[]' "$sources"); do
  json_file="$vendor_dir/$id.json"
  [ -f "$json_file" ] || continue
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
done
