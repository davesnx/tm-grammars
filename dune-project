(lang dune 3.17)

(name tm-grammars)

(version 0.1.0)

(generate_opam_files true)

(source
 (github davesnx/tm-grammars))

(license MIT)

(package
 (name tm-grammars)
 (synopsis "TextMate grammars as OCaml strings")
 (description
  "OCaml package that exposes TextMate grammars as JSON strings.")
 (authors "David Sancho <dsnxmoreno@gmail.com>")
 (maintainers "David Sancho <dsnxmoreno@gmail.com>")
 (depends
  ocaml))

(package
 (name tm-themes)
 (synopsis "TextMate themes as OCaml strings")
 (description
  "OCaml package that exposes the Shiki TextMate themes as JSON strings.")
 (license "MIT AND Apache-2.0 AND GPL-3.0-only")
 (authors "David Sancho <dsnxmoreno@gmail.com>")
 (maintainers "David Sancho <dsnxmoreno@gmail.com>")
 (depends
  ocaml))
