ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

case "${1:-}" in
  grammars)
    sources="$ROOT_DIR/sources.json"
    vendor_dir="$ROOT_DIR/vendor"
    packages_dir="$ROOT_DIR/packages"
    package="tm-grammars"
    module_prefix="tm_grammar_"
    id_value="lang_id"
    label="grammar"
    ;;
  themes)
    sources="$ROOT_DIR/themes.json"
    vendor_dir="$ROOT_DIR/vendor-themes"
    packages_dir="$ROOT_DIR/packages-themes"
    package="tm-themes"
    module_prefix="tm_theme_"
    id_value="name"
    label="theme"
    ;;
  *)
    echo "usage: $0 <grammars|themes> [id...]" >&2
    exit 1
    ;;
esac

index_module="$(echo "$package" | tr '-' '_')"

public_id() {
  if [ "$package" = "tm-grammars" ] && [ "$1" = "opam" ]; then
    echo "opam-file"
  else
    echo "$1"
  fi
}

module_name() {
  echo "${module_prefix}$(echo "$1" | tr '-' '_')"
}

capitalize() {
  echo "$(echo "${1:0:1}" | tr '[:lower:]' '[:upper:]')${1:1}"
}

format_ocaml() {
  if command -v ocamlformat >/dev/null 2>&1; then
    ocamlformat --enable-outside-detected-project --name "$1" --impl -i "$1"
    ocamlformat --enable-outside-detected-project --name "$2" --intf -i "$2"
  fi
}
