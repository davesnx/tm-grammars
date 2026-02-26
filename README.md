# tm-grammars

OCaml packages that expose TextMate grammars as JSON strings.

## Supported language ids

`c`, `cpp`, `cram`, `css`, `diff`, `dockerfile`, `dune`, `go`, `graphql`, `html`, `java`, `javascript`, `json`, `jsonc`, `makefile`, `markdown`, `menhir`, `mlx`, `ocaml`, `ocamllex`, `opam`, `python`, `reason`, `ruby`, `rust`, `shellscript`, `sql`, `toml`, `tsx`, `typescript`, `yaml`.

## Install all grammars

```bash
opam install tm-grammars
```

Use the bundled package with direct accessors:

```ocaml
let grammar_ocaml = Tm_grammars_all.ocaml
let grammar_tsx = Tm_grammars_all.tsx
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
