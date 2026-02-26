#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <sources.json>" >&2
  exit 1
fi

sources_json="$1"

mapfile -t lang_ids < <(jq -r 'keys[]' "$sources_json")

ml_file="tm_grammars_all.ml"
mli_file="tm_grammars_all.mli"

{
  printf '%s\n' "let all = ["
  for lang_id in "${lang_ids[@]}"; do
    module_name="tm_grammar_$(echo "$lang_id" | tr '-' '_')"
    capitalized="$(echo "${module_name:0:1}" | tr '[:lower:]' '[:upper:]')${module_name:1}"
    printf '  (%s.lang_id, %s.json);\n' "$capitalized" "$capitalized"
  done
  printf '%s\n\n' "]"
  printf '%s\n\n' "let available = List.map fst all"
  printf '%s\n' "let find lang_id = List.assoc_opt lang_id all"
} > "$ml_file"

cat > "$mli_file" <<'EOF'
val all : (string * string) list
val available : string list
val find : string -> string option
EOF

if command -v ocamlformat >/dev/null 2>&1; then
  ocamlformat --enable-outside-detected-project --name "$ml_file" --impl -i "$ml_file"
  ocamlformat --enable-outside-detected-project --name "$mli_file" --intf -i "$mli_file"
fi
