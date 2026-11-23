.patterns |= (
  (map(.include) | index("#bindings")) as $i
  | if $i == null then error("ocaml-interface: no #bindings include in patterns") else . end
  | .[:$i] + [{"include": "source.ocaml#module-names"}] + .[$i:]
)

| .repository.bindings.patterns |= [{"include": "source.ocaml#type-definition"}, {"include": "source.ocaml#type-annotation"}] + map(
  if .comment == "type declaration" then .captures."4".name = "entity.name.type.ocaml" else . end
)
