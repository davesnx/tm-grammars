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

`abap`, `actionscript-3`, `ada`, `angular-expression`, `angular-html`, `angular-inline-style`, `angular-inline-template`, `angular-let-declaration`, `angular-template`, `angular-template-blocks`, `angular-ts`, `apache`, `apex`, `apl`, `applescript`, `ara`, `asciidoc`, `asm`, `astro`, `awk`, `ballerina`, `bat`, `beancount`, `berry`, `bibtex`, `bicep`, `bird2`, `blade`, `bsl`, `c`, `c3`, `cadence`, `cairo`, `clarity`, `clojure`, `cmake`, `cobol`, `codeowners`, `codeql`, `coffee`, `common-lisp`, `coq`, `cpp`, `cpp-macro`, `cram`, `crystal`, `csharp`, `css`, `csv`, `cue`, `cypher`, `d`, `dart`, `dax`, `desktop`, `diff`, `dockerfile`, `dotenv`, `dream-maker`, `dune`, `edge`, `elixir`, `elm`, `emacs-lisp`, `erb`, `erlang`, `es-tag-css`, `es-tag-glsl`, `es-tag-html`, `es-tag-sql`, `es-tag-xml`, `fennel`, `fish`, `fluent`, `fortran-fixed-form`, `fortran-free-form`, `fsharp`, `gdresource`, `gdscript`, `gdshader`, `genie`, `gherkin`, `git-commit`, `git-rebase`, `gleam`, `glimmer-js`, `glimmer-ts`, `glsl`, `gn`, `gnuplot`, `go`, `graphql`, `groovy`, `hack`, `haml`, `handlebars`, `haskell`, `haxe`, `hcl`, `hjson`, `hlsl`, `html`, `html-derivative`, `http`, `hurl`, `hxml`, `hy`, `imba`, `ini`, `java`, `javascript`, `jinja`, `jinja-html`, `jison`, `json`, `json5`, `jsonc`, `jsonl`, `jsonnet`, `jssm`, `jsx`, `julia`, `just`, `kdl`, `kotlin`, `kusto`, `latex`, `lean`, `less`, `liquid`, `llvm`, `log`, `logo`, `lua`, `luau`, `makefile`, `markdown`, `markdown-nix`, `markdown-vue`, `marko`, `matlab`, `mdc`, `mdx`, `menhir`, `mermaid`, `mipsasm`, `mlx`, `mojo`, `moonbit`, `move`, `narrat`, `nextflow`, `nextflow-groovy`, `nginx`, `nim`, `nix`, `nushell`, `objective-c`, `objective-cpp`, `ocaml`, `ocamllex`, `odin`, `opam`, `openscad`, `pascal`, `perl`, `php`, `pkl`, `plsql`, `po`, `polar`, `postcss`, `powerquery`, `powershell`, `prisma`, `prolog`, `proto`, `pug`, `puppet`, `purescript`, `python`, `qml`, `qmldir`, `qss`, `r`, `racket`, `raku`, `razor`, `reason`, `reg`, `regexp`, `rel`, `riscv`, `ron`, `rosmsg`, `rst`, `ruby`, `rust`, `sas`, `sass`, `scala`, `scheme`, `scss`, `sdbl`, `shaderlab`, `shellscript`, `shellsession`, `smalltalk`, `solidity`, `soy`, `sparql`, `splunk`, `sql`, `ssh-config`, `stata`, `stylus`, `surrealql`, `svelte`, `swift`, `system-verilog`, `systemd`, `talonscript`, `tasl`, `tcl`, `templ`, `terraform`, `tex`, `toml`, `ts-tags`, `tsv`, `tsx`, `turtle`, `twig`, `typescript`, `typespec`, `typst`, `v`, `vala`, `vb`, `verilog`, `vhdl`, `viml`, `vue`, `vue-directives`, `vue-html`, `vue-interpolations`, `vue-sfc-style-variable-injection`, `vue-vine`, `vyper`, `wasm`, `wenyan`, `wgsl`, `wikitext`, `wit`, `wolfram`, `xml`, `xsl`, `yaml`, `zenscript`, `zig`.

### How to add a new grammar

1. Add a new entry in [sources.json](sources.json) with the language id, upstream source (`repo`, `path`, `commit`), and license metadata (`license`, optional `licenseUrl`, optional `originalSource`).
2. Run `make sync` to download the grammar into `vendor/<language-id>.json`.
3. Run `make generate` to regenerate packages and metadata.
4. Run `make build` (and optionally `make test`) to verify everything still builds.

## License

MIT. See `LICENSE`.
