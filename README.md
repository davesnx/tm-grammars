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

### Grammars that include other grammars

A grammar can include rules from another grammar by scope name. Load both grammars into the same registry. The `ocaml` grammar (`source.ocaml`) includes `ocaml-interface` (`source.ocaml.interface`) for labels, `type`, `and`, `external`, `val`, class and `sig ... end` rules:

```dune
(libraries tm-grammars.ocaml tm-grammars.ocaml-interface)
```

```ocaml
let grammars =
  [ (Tm_grammar_ocaml.lang_id, Tm_grammar_ocaml.json);
    (Tm_grammar_ocaml_interface.lang_id, Tm_grammar_ocaml_interface.json) ]
```

## Supported language ids

`abap`, `actionscript-3`, `ada`, `angular-expression`, `angular-html`, `angular-inline-style`, `angular-inline-template`, `angular-let-declaration`, `angular-template`, `angular-template-blocks`, `angular-ts`, `apache`, `apex`, `apl`, `applescript`, `ara`, `asciidoc`, `asm`, `astro`, `awk`, `ballerina`, `bat`, `beancount`, `berry`, `bibtex`, `bicep`, `bird2`, `blade`, `bsl`, `c`, `c3`, `cadence`, `cairo`, `clarity`, `clojure`, `cmake`, `cobol`, `codeowners`, `codeql`, `coffee`, `common-lisp`, `coq`, `cpp`, `cpp-macro`, `cram`, `crystal`, `csharp`, `css`, `csv`, `cue`, `cypher`, `d`, `dart`, `dax`, `desktop`, `diff`, `dockerfile`, `dotenv`, `dream-maker`, `dune`, `edge`, `elixir`, `elm`, `emacs-lisp`, `erb`, `erlang`, `es-tag-css`, `es-tag-glsl`, `es-tag-html`, `es-tag-sql`, `es-tag-xml`, `fennel`, `fish`, `fluent`, `fortran-fixed-form`, `fortran-free-form`, `fsharp`, `gdresource`, `gdscript`, `gdshader`, `genie`, `gherkin`, `git-commit`, `git-rebase`, `gleam`, `glimmer-js`, `glimmer-ts`, `glsl`, `gn`, `gnuplot`, `go`, `graphql`, `groovy`, `hack`, `haml`, `handlebars`, `haskell`, `haxe`, `hcl`, `hjson`, `hlsl`, `html`, `html-derivative`, `http`, `hurl`, `hxml`, `hy`, `imba`, `ini`, `java`, `javascript`, `jinja`, `jinja-html`, `jison`, `json`, `json5`, `jsonc`, `jsonl`, `jsonnet`, `jssm`, `jsx`, `julia`, `just`, `kdl`, `kotlin`, `kusto`, `latex`, `lean`, `less`, `liquid`, `llvm`, `log`, `logo`, `lua`, `luau`, `makefile`, `markdown`, `markdown-nix`, `markdown-vue`, `marko`, `matlab`, `mdc`, `mdx`, `menhir`, `mermaid`, `mipsasm`, `mlx`, `mojo`, `moonbit`, `move`, `narrat`, `nextflow`, `nextflow-groovy`, `nginx`, `nim`, `nix`, `nushell`, `objective-c`, `objective-cpp`, `ocaml`, `ocaml-interface`, `ocamllex`, `odin`, `opam`, `openscad`, `pascal`, `perl`, `php`, `pkl`, `plsql`, `po`, `polar`, `postcss`, `powerquery`, `powershell`, `prisma`, `prolog`, `proto`, `pug`, `puppet`, `purescript`, `python`, `qml`, `qmldir`, `qss`, `r`, `racket`, `raku`, `razor`, `reason`, `reg`, `regexp`, `rel`, `riscv`, `ron`, `rosmsg`, `rst`, `ruby`, `rust`, `sas`, `sass`, `scala`, `scheme`, `scss`, `sdbl`, `shaderlab`, `shellscript`, `shellsession`, `smalltalk`, `solidity`, `soy`, `sparql`, `splunk`, `sql`, `ssh-config`, `stata`, `stylus`, `surrealql`, `svelte`, `swift`, `system-verilog`, `systemd`, `talonscript`, `tasl`, `tcl`, `templ`, `terraform`, `tex`, `toml`, `ts-tags`, `tsv`, `tsx`, `turtle`, `twig`, `typescript`, `typespec`, `typst`, `v`, `vala`, `vb`, `verilog`, `vhdl`, `viml`, `vue`, `vue-directives`, `vue-html`, `vue-interpolations`, `vue-sfc-style-variable-injection`, `vue-vine`, `vyper`, `wasm`, `wenyan`, `wgsl`, `wikitext`, `wit`, `wolfram`, `xml`, `xsl`, `yaml`, `zenscript`, `zig`.

### How to add a new grammar

1. Add a new entry in [sources.json](sources.json) with the language id, upstream source (`repo`, `path`, `commit`), and license metadata (`license`, optional `licenseUrl`, optional `originalSource`).
2. Run `make sync` to download the grammar into `vendor/<language-id>.json`. Use `make sync LANGS="<language-id> ..."` to download only some grammars.
3. Run `make generate` to regenerate packages and metadata.
4. Run `make build` (and optionally `make test`) to verify everything still builds.

### How to change a grammar

`make sync` applies `scripts/patches/<language-id>.jq` (a jq program) to the downloaded grammar, so local changes stay after the next sync. Patches shared by several grammars live in `scripts/patches/lib/` as jq modules: `ocaml.jq` and `mlx.jq` both include `lib/ocaml-roles.jq`, because mlx carries its own copy of the OCaml rules. Edit the patch, then run `make sync LANGS="<language-id>"` and `make generate`. `make test-scopes` checks the token scopes of the patched OCaml grammars with vscode-textmate (needs Node.js 22.18 or later).

## Themes

The [tm-themes] package exposes the Shiki TextMate themes as JSON strings in the same way. Each theme is a library ([tm-themes.nord], [tm-themes.dark-plus], etc.).

```dune
(libraries tm-themes)
```

```ocaml
let nord = Tm_themes.nord
let dark_plus = Tm_themes.find "dark-plus"   (* string option *)
let names = Tm_themes.available            (* string list *)
```

Depend on a sublibrary to pull in only one theme:

```dune
(libraries tm-themes.nord)
```

```ocaml
let nord = Tm_theme_nord.json
```

### Supported theme ids

`andromeeda`, `aurora-x`, `ayu-dark`, `ayu-light`, `ayu-mirage`, `catppuccin-frappe`, `catppuccin-latte`, `catppuccin-macchiato`, `catppuccin-mocha`, `dark-plus`, `dracula`, `dracula-soft`, `everforest-dark`, `everforest-light`, `github-dark`, `github-dark-default`, `github-dark-dimmed`, `github-dark-high-contrast`, `github-light`, `github-light-default`, `github-light-high-contrast`, `gruvbox-dark-hard`, `gruvbox-dark-medium`, `gruvbox-dark-soft`, `gruvbox-light-hard`, `gruvbox-light-medium`, `gruvbox-light-soft`, `horizon`, `horizon-bright`, `houston`, `kanagawa-dragon`, `kanagawa-lotus`, `kanagawa-wave`, `laserwave`, `light-plus`, `material-theme`, `material-theme-darker`, `material-theme-lighter`, `material-theme-ocean`, `material-theme-palenight`, `min-dark`, `min-light`, `monokai`, `night-owl`, `night-owl-light`, `nord`, `one-dark-pro`, `one-light`, `plastic`, `poimandres`, `red`, `rose-pine`, `rose-pine-dawn`, `rose-pine-moon`, `slack-dark`, `slack-ochin`, `snazzy-light`, `solarized-dark`, `solarized-light`, `synthwave-84`, `tokyo-night`, `vesper`, `vitesse-black`, `vitesse-dark`, `vitesse-light`.

### How to add a new theme

Add an entry in [themes.json](themes.json), run `make sync` to download it into `vendor-themes/<theme-id>.json`, then run `make generate` and `make build`. Use `make sync THEMES="<theme-id> ..."` to download only some themes.

## License

The code is MIT (see `LICENSE`). Each grammar and theme keeps the license of its upstream source, listed in `sources.json`, `themes.json` and `THIRD-PARTY-LICENSES`.
