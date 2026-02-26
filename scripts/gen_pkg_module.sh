#!/usr/bin/env bash
set -euo pipefail

if [ "$#" -ne 2 ]; then
  echo "usage: $0 <lang-id> <json-file>" >&2
  exit 1
fi

lang_id="$1"
json_file="$2"
module_name="tm_grammar_$(echo "$lang_id" | tr '-' '_')"

content="$(<"$json_file")"
delim="json"
while [[ "$content" == *"|${delim}}"* ]]; do
  delim="${delim}_"
done

cat > "${module_name}.ml" <<EOF
let lang_id = "${lang_id}"
let json = {${delim}|${content}|${delim}}
EOF

cat > "${module_name}.mli" <<'EOF'
val lang_id : string
val json : string
EOF

if command -v ocamlformat >/dev/null 2>&1; then
  ocamlformat --enable-outside-detected-project --name "${module_name}.ml" --impl -i "${module_name}.ml"
  ocamlformat --enable-outside-detected-project --name "${module_name}.mli" --intf -i "${module_name}.mli"
fi
