#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/kind.sh"

ids=()
while IFS= read -r id; do
  ids+=("${id%$'\r'}")
done < <(jq -r 'keys[]' "$sources")

ml_file="$packages_dir/$package/$index_module.ml"
mli_file="$packages_dir/$package/$index_module.mli"

{
  for id in "${ids[@]}"; do
    printf 'let %s = %s.json\n' "$(echo "$id" | tr '-' '_')" "$(capitalize "$(module_name "$id")")"
  done
  printf '\n'
  printf '%s\n' "let all = ["
  for id in "${ids[@]}"; do
    module="$(capitalize "$(module_name "$id")")"
    printf '  (%s.%s, %s.json);\n' "$module" "$id_value" "$module"
  done
  printf '%s\n\n' "]"
  printf '%s\n\n' "let available = List.map fst all"
  printf 'let find %s = List.assoc_opt %s all\n' "$id_value" "$id_value"
} > "$ml_file"

{
  for id in "${ids[@]}"; do
    printf 'val %s : string\n' "$(echo "$id" | tr '-' '_')"
  done
  printf '\n'
  printf '%s\n' 'val all : (string * string) list'
  printf '%s\n' 'val available : string list'
  printf '%s\n' 'val find : string -> string option'
} > "$mli_file"

format_ocaml "$ml_file" "$mli_file"
