# tm-grammars

OCaml packages that expose TextMate grammars as JSON strings.

## Install all grammars

```bash
opam install tm-grammars
```

Use the bundled package with direct accessors:

```ocaml
let grammar_ocaml = Tm_grammars.ocaml
let grammar_tsx = Tm_grammars.tsx
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

## Supported language ids

`c`, `cpp`, `cram`, `css`, `diff`, `dockerfile`, `dune`, `go`, `graphql`, `html`, `java`, `javascript`, `json`, `jsonc`, `makefile`, `markdown`, `menhir`, `mlx`, `ocaml`, `ocamllex`, `opam`, `python`, `reason`, `ruby`, `rust`, `shellscript`, `sql`, `toml`, `tsx`, `typescript`, `yaml`.

### How to add a new grammar

1. Add a new entry in [sources.json](sources.json) with the language id and upstream source (`repo`, `path`, `commit`).
2. Run `make sync` to download the grammar into `vendor/<language-id>.json`.
3. Run `make generate` to regenerate packages and metadata.
4. Run `make build` (and optionally `make test`) to verify everything still builds.

## License

MIT. See `LICENSE`.
