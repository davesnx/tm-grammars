let all =
  [
    (Tm_grammar_c.lang_id, Tm_grammar_c.json);
    (Tm_grammar_cpp.lang_id, Tm_grammar_cpp.json);
    (Tm_grammar_cram.lang_id, Tm_grammar_cram.json);
    (Tm_grammar_css.lang_id, Tm_grammar_css.json);
    (Tm_grammar_diff.lang_id, Tm_grammar_diff.json);
    (Tm_grammar_dockerfile.lang_id, Tm_grammar_dockerfile.json);
    (Tm_grammar_dune.lang_id, Tm_grammar_dune.json);
    (Tm_grammar_go.lang_id, Tm_grammar_go.json);
    (Tm_grammar_graphql.lang_id, Tm_grammar_graphql.json);
    (Tm_grammar_html.lang_id, Tm_grammar_html.json);
    (Tm_grammar_java.lang_id, Tm_grammar_java.json);
    (Tm_grammar_javascript.lang_id, Tm_grammar_javascript.json);
    (Tm_grammar_json.lang_id, Tm_grammar_json.json);
    (Tm_grammar_jsonc.lang_id, Tm_grammar_jsonc.json);
    (Tm_grammar_makefile.lang_id, Tm_grammar_makefile.json);
    (Tm_grammar_markdown.lang_id, Tm_grammar_markdown.json);
    (Tm_grammar_menhir.lang_id, Tm_grammar_menhir.json);
    (Tm_grammar_mlx.lang_id, Tm_grammar_mlx.json);
    (Tm_grammar_ocaml.lang_id, Tm_grammar_ocaml.json);
    (Tm_grammar_ocamllex.lang_id, Tm_grammar_ocamllex.json);
    (Tm_grammar_opam.lang_id, Tm_grammar_opam.json);
    (Tm_grammar_python.lang_id, Tm_grammar_python.json);
    (Tm_grammar_reason.lang_id, Tm_grammar_reason.json);
    (Tm_grammar_ruby.lang_id, Tm_grammar_ruby.json);
    (Tm_grammar_rust.lang_id, Tm_grammar_rust.json);
    (Tm_grammar_shellscript.lang_id, Tm_grammar_shellscript.json);
    (Tm_grammar_sql.lang_id, Tm_grammar_sql.json);
    (Tm_grammar_toml.lang_id, Tm_grammar_toml.json);
    (Tm_grammar_tsx.lang_id, Tm_grammar_tsx.json);
    (Tm_grammar_typescript.lang_id, Tm_grammar_typescript.json);
    (Tm_grammar_yaml.lang_id, Tm_grammar_yaml.json);
  ]

let available = List.map fst all
let find lang_id = List.assoc_opt lang_id all
