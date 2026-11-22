#!/usr/bin/env bash
set -euo pipefail

source "$(dirname "${BASH_SOURCE[0]}")/kind.sh"

mapfile -t ids < <(jq -r 'keys[]' "$sources")

for id in "${ids[@]}"; do
  mkdir -p "$packages_dir/$id"
  cat > "$packages_dir/$id/dune" <<DUNE
(library
 (name $(module_name "$id"))
 (public_name $package.$(public_id "$id")))
DUNE
done

mkdir -p "$packages_dir/$package"
{
  echo "(library"
  echo " (name $index_module)"
  echo " (public_name $package)"
  echo " (libraries"
  last_idx=$(( ${#ids[@]} - 1 ))
  for i in "${!ids[@]}"; do
    if [ "$i" -eq "$last_idx" ]; then
      printf '  %s.%s))\n' "$package" "$(public_id "${ids[$i]}")"
    else
      printf '  %s.%s\n' "$package" "$(public_id "${ids[$i]}")"
    fi
  done
} > "$packages_dir/$package/dune"
