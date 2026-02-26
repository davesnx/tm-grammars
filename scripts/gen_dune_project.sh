#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "usage: $0 <sources.json>" >&2
  exit 1
fi

sources_json="$1"

mapfile -t lang_ids < <(jq -r 'keys[]' "$sources_json")

tmp_file="$(mktemp)"
trap 'rm -f "$tmp_file"' EXIT

cat > "$tmp_file" <<'EOF'
(lang dune 3.17)

(name tm-grammars)

(version 0.1.0)

(generate_opam_files true)

(source
 (github davesnx/tm-grammars))

(license MIT)
EOF

for lang_id in "${lang_ids[@]}"; do
  pkg_name="tm-grammar-${lang_id}"
  cat >> "$tmp_file" <<EOF

(package
 (name ${pkg_name})
 (synopsis "TextMate grammar for ${lang_id}")
 (depends
  (ocaml
   (>= 5.2.0))))
EOF
done

printf '\n' >> "$tmp_file"
printf '%s\n' "(package" >> "$tmp_file"
printf '%s\n' " (name tm-grammars-all)" >> "$tmp_file"
printf '%s\n' " (synopsis \"All bundled TextMate grammars\")" >> "$tmp_file"
printf '%s\n' " (depends" >> "$tmp_file"
printf '%s\n' "  (ocaml" >> "$tmp_file"
printf '%s\n' "   (>= 5.2.0))" >> "$tmp_file"
for lang_id in "${lang_ids[@]}"; do
  printf '%s\n' "  tm-grammar-${lang_id}" >> "$tmp_file"
done
printf '%s\n' " ))" >> "$tmp_file"

if command -v dune >/dev/null 2>&1; then
  dune format-dune-file "$tmp_file" >/dev/null 2>&1 || true
fi

cat "$tmp_file"
