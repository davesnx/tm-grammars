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

for lang_id in "${lang_ids[@]}"; do
  module_name="tm_grammar_$(echo "$lang_id" | tr '-' '_')"
  package_dir="$ROOT_DIR/packages/$lang_id"
  public_id="$lang_id"

  if [ "$lang_id" = "opam" ]; then
    public_id="opam-file"
  fi

  mkdir -p "$package_dir"
  cat > "$package_dir/dune" <<EOF
(library
 (name $module_name)
 (public_name tm-grammars.$public_id))
EOF
done

tm_grammars_dune="$ROOT_DIR/packages/tm-grammars/dune"
{
  echo "(library"
  echo " (name tm_grammars)"
  echo " (public_name tm-grammars)"
  echo " (libraries"
  last_idx=$(( ${#lang_ids[@]} - 1 ))
  for i in "${!lang_ids[@]}"; do
    lang_id="${lang_ids[$i]}"
    public_id="$lang_id"
    if [ "$lang_id" = "opam" ]; then
      public_id="opam-file"
    fi
    if [ "$i" -eq "$last_idx" ]; then
      printf '  tm-grammars.%s))\n' "$public_id"
    else
      printf '  tm-grammars.%s\n' "$public_id"
    fi
  done
} > "$tm_grammars_dune"
