(lang dune 3.17)

(name tm-grammars)

(version 0.1.0)

(generate_opam_files true)

(source
 (github davesnx/tm-grammars))

(license MIT)

(package
 (name tm-grammar-c)
 (synopsis "TextMate grammar for c")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-cpp)
 (synopsis "TextMate grammar for cpp")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-cram)
 (synopsis "TextMate grammar for cram")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-css)
 (synopsis "TextMate grammar for css")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-diff)
 (synopsis "TextMate grammar for diff")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-dockerfile)
 (synopsis "TextMate grammar for dockerfile")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-dune)
 (synopsis "TextMate grammar for dune")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-go)
 (synopsis "TextMate grammar for go")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-graphql)
 (synopsis "TextMate grammar for graphql")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-html)
 (synopsis "TextMate grammar for html")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-java)
 (synopsis "TextMate grammar for java")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-javascript)
 (synopsis "TextMate grammar for javascript")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-json)
 (synopsis "TextMate grammar for json")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-jsonc)
 (synopsis "TextMate grammar for jsonc")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-makefile)
 (synopsis "TextMate grammar for makefile")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-markdown)
 (synopsis "TextMate grammar for markdown")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-menhir)
 (synopsis "TextMate grammar for menhir")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-mlx)
 (synopsis "TextMate grammar for mlx")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-ocaml)
 (synopsis "TextMate grammar for ocaml")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-ocamllex)
 (synopsis "TextMate grammar for ocamllex")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-opam)
 (synopsis "TextMate grammar for opam")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-python)
 (synopsis "TextMate grammar for python")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-reason)
 (synopsis "TextMate grammar for reason")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-ruby)
 (synopsis "TextMate grammar for ruby")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-rust)
 (synopsis "TextMate grammar for rust")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-shellscript)
 (synopsis "TextMate grammar for shellscript")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-sql)
 (synopsis "TextMate grammar for sql")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-toml)
 (synopsis "TextMate grammar for toml")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-tsx)
 (synopsis "TextMate grammar for tsx")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-typescript)
 (synopsis "TextMate grammar for typescript")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammar-yaml)
 (synopsis "TextMate grammar for yaml")
 (depends
  (ocaml
   (>= 5.2.0))))

(package
 (name tm-grammars-all)
 (synopsis "All bundled TextMate grammars")
 (depends
  (ocaml
   (>= 5.2.0))
  tm-grammar-c
  tm-grammar-cpp
  tm-grammar-cram
  tm-grammar-css
  tm-grammar-diff
  tm-grammar-dockerfile
  tm-grammar-dune
  tm-grammar-go
  tm-grammar-graphql
  tm-grammar-html
  tm-grammar-java
  tm-grammar-javascript
  tm-grammar-json
  tm-grammar-jsonc
  tm-grammar-makefile
  tm-grammar-markdown
  tm-grammar-menhir
  tm-grammar-mlx
  tm-grammar-ocaml
  tm-grammar-ocamllex
  tm-grammar-opam
  tm-grammar-python
  tm-grammar-reason
  tm-grammar-ruby
  tm-grammar-rust
  tm-grammar-shellscript
  tm-grammar-sql
  tm-grammar-toml
  tm-grammar-tsx
  tm-grammar-typescript
  tm-grammar-yaml
 ))
