#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
VENDOR_DIR="$ROOT_DIR/vendor"
PACKAGES_DIR="$ROOT_DIR/packages"

if [ ! -d "$VENDOR_DIR" ] || [ -z "$(ls -A "$VENDOR_DIR" 2>/dev/null)" ]; then
  echo "error: vendor/ is empty. Run 'make sync' first." >&2
  exit 1
fi

to_module_name() {
  echo "$1" | tr '-' '_'
}

find_safe_delimiter() {
  local content="$1"
  local delim="json"
  while grep -qF "|${delim}}" <<< "$content"; do
    delim="${delim}_"
  done
  echo "$delim"
}

rm -rf "$PACKAGES_DIR"
mkdir -p "$PACKAGES_DIR"

all_lang_ids=()
all_module_names=()
all_pkg_names=()

for json_file in "$VENDOR_DIR"/*.json; do
  lang_id=$(basename "$json_file" .json)
  module_name="tm_grammar_$(to_module_name "$lang_id")"
  pkg_name="tm-grammar-${lang_id}"
  pkg_dir="$PACKAGES_DIR/$pkg_name"

  all_lang_ids+=("$lang_id")
  all_module_names+=("$module_name")
  all_pkg_names+=("$pkg_name")

  mkdir -p "$pkg_dir"

  content=$(cat "$json_file")
  delim=$(find_safe_delimiter "$content")

  # .ml
  cat > "$pkg_dir/$module_name.ml" <<MLEOF
let lang_id = "$lang_id"

let json = {${delim}|${content}|${delim}}
MLEOF

  # .mli
  cat > "$pkg_dir/$module_name.mli" <<MLIEOF
val lang_id : string
val json : string
MLIEOF

  # dune
  cat > "$pkg_dir/dune" <<DUNEOF
(library
 (name $module_name)
 (public_name $pkg_name))
DUNEOF

  echo "  generated $pkg_name"
done

# --- tm-grammars-all meta-package ---

all_dir="$PACKAGES_DIR/tm-grammars-all"
mkdir -p "$all_dir"

deps=""
for pkg in "${all_pkg_names[@]}"; do
  deps="$deps $pkg"
done

cat > "$all_dir/dune" <<DUNEOF
(library
 (name tm_grammars_all)
 (public_name tm-grammars-all)
 (libraries${deps}))
DUNEOF

# .ml
{
  echo "let all = ["
  for i in "${!all_lang_ids[@]}"; do
    mod="${all_module_names[$i]}"
    capitalized=$(echo "${mod:0:1}" | tr '[:lower:]' '[:upper:]')${mod:1}
    echo "  (${capitalized}.lang_id, ${capitalized}.json);"
  done
  echo "]"
  echo ""
  echo "let available = List.map fst all"
  echo ""
  echo "let find lang_id = List.assoc_opt lang_id all"
} > "$all_dir/tm_grammars_all.ml"

# .mli
cat > "$all_dir/tm_grammars_all.mli" <<'MLIEOF'
val all : (string * string) list
val available : string list
val find : string -> string option
MLIEOF

echo "  generated tm-grammars-all"

# --- dune-project ---

{
  cat <<'HEADER'
(lang dune 3.17)

(name tm-grammars)

(version 0.1.0)

(generate_opam_files true)

(source
 (github davesnx/tm-grammars))

(license MIT)

HEADER

  for i in "${!all_pkg_names[@]}"; do
    pkg="${all_pkg_names[$i]}"
    lang="${all_lang_ids[$i]}"
    cat <<PKGEOF

(package
 (name $pkg)
 (synopsis "TextMate grammar for $lang")
 (depends
  (ocaml
   (>= 5.2.0))))
PKGEOF
  done

  # tm-grammars-all depends on every individual package
  echo ""
  echo "(package"
  echo " (name tm-grammars-all)"
  echo " (synopsis \"All bundled TextMate grammars\")"
  echo " (depends"
  echo "  (ocaml"
  echo "   (>= 5.2.0))"
  for pkg in "${all_pkg_names[@]}"; do
    echo "  $pkg"
  done
  echo "))"

} > "$ROOT_DIR/dune-project"

echo "  generated dune-project"

echo ""
echo "Done. Generated ${#all_lang_ids[@]} grammar packages + tm-grammars-all."
