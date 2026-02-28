## 1.0.0

- Published OCaml package that exposes TextMate grammars as JSON strings.
- Each language is a findlib sublibrary (e.g. `tm-grammars.ocaml`, `tm-grammars.tsx`).
- Downstream users depend on `tm-grammars` and add only the sublibraries they need to `(libraries ...)`.
- Generated package setup driven by `sources.json`.
