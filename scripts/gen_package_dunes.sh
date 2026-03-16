#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <sources.json>" >&2
  exit 1
fi

sources_json="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

mapfile -t lang_ids < <(jq -r 'keys[]' "$sources_json")

declare -A wanted=()
for lang_id in "${lang_ids[@]}"; do
  wanted["$lang_id"]=1
done

for dir in "$ROOT_DIR"/packages/tm-grammar-*; do
  [ -d "$dir" ] || continue
  id="$(basename "$dir")"
  id="${id#tm-grammar-}"
  if [ -z "${wanted[$id]+x}" ]; then
    rm -rf "$dir"
  fi
done

for lang_id in "${lang_ids[@]}"; do
  module_name="tm_grammar_$(echo "$lang_id" | tr '-' '_')"
  package_dir="$ROOT_DIR/packages/tm-grammar-$lang_id"
  public_id="$lang_id"

  if [ "$lang_id" = "opam" ]; then
    public_id="opam-file"
  fi

  mkdir -p "$package_dir"
  cat > "$package_dir/dune" <<EOF
(library
 (name $module_name)
 (public_name tm-grammars.$public_id))

(rule
 (alias gen)
 (deps ../../vendor/$lang_id.json ../../scripts/gen_pkg_module.sh)
 (targets $module_name.ml $module_name.mli)
 (mode
  (promote (until-clean)))
 (action
  (run bash ../../scripts/gen_pkg_module.sh $lang_id ../../vendor/$lang_id.json)))
EOF
done

tm_grammars_dune="$ROOT_DIR/packages/tm-grammars/dune"
{
  echo "(library"
  echo " (name tm_grammars)"
  echo " (public_name tm-grammars)"
  echo " (libraries"
  for lang_id in "${lang_ids[@]}"; do
    public_id="$lang_id"
    if [ "$lang_id" = "opam" ]; then
      public_id="opam-file"
    fi
    printf '  tm-grammars.%s\n' "$public_id"
  done
  echo "  ))"
  echo ""
  echo "(rule"
  echo " (alias gen)"
  echo " (deps ../../sources.json ../../scripts/gen_all_module.sh)"
  echo " (targets tm_grammars.ml tm_grammars.mli)"
  echo " (mode"
  echo "  (promote (until-clean)))"
  echo " (action"
  echo "  (run bash ../../scripts/gen_all_module.sh ../../sources.json)))"
} > "$tm_grammars_dune"
