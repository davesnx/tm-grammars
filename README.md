# tm-grammars

OCaml package that exposes TextMate grammars as JSON strings. Each language is available as a library ([tm-grammars.ocaml], [tm-grammars.tsx], etc.) so downstream users only link what they need.

## Install

```bash
opam install tm-grammars -y
```

## Usage

```dune
(libraries tm-grammars)
```

```ocaml
let grammar_ocaml = Tm_grammars.ocaml
let grammar_tsx = Tm_grammars.tsx
```

You can also list grammars dynamically:

```ocaml
let all = Tm_grammars.all          (* (string * string) list *)
let ids = Tm_grammars.available    (* string list *)
```

## Use a single grammar

Depend on a sublibrary to pull in only the grammar you need.

```dune
(libraries tm-grammars.ocaml tm-grammars.tsx)
```

```ocaml
let grammar_ocaml = Tm_grammar_ocaml.json
let grammar_tsx = Tm_grammar_tsx.json
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
