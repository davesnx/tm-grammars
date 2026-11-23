include "lib/ocaml-roles" {search: "./"};

.fileTypes |= ((. + ["mli", "eliomi"]) | unique)
| ocaml_roles
