include "lib/ocaml-roles" {search: "./"};

ocaml_roles

| .repository."jsx-head".patterns |= (
    (map(.begin) | index("\\G")) as $i
    | if $i == null then error("mlx: no tag name rule in jsx-head") else . end
    | .[$i].patterns |= [qualifier] + .
  )

| .repository."jsx-tail".patterns |= [qualifier] + .

| .repository."jsx-expression".patterns |= [field_access] + .
