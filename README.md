# tm-grammars

OCaml packages that expose TextMate grammars as JSON strings.

## Install all grammars

```bash
opam install tm-grammars-all
```

Use the bundled package and look up by language id:

```ocaml
let grammar_ocaml_opt = Tm_grammars_all.find "ocaml"
let grammar_tsx_opt = Tm_grammars_all.find "tsx"
```

## Install one grammar

Examples with `ocaml` and `tsx` (you can also replace these with any supported language id).

```bash
opam install tm-grammar-ocaml
opam install tm-grammar-tsx
```

Use one grammar package:

```ocaml
let grammar_ocaml = Tm_grammar_ocaml.ocaml
let grammar_tsx = Tm_grammar_tsx.tsx
```

## License

MIT. See `LICENSE`.
