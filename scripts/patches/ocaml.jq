def lower: "[[:lower:]_][[:word:]']*";
def upper: "[[:upper:]][[:word:]']*+";
def period: "keyword.other.ocaml punctuation.other.period punctuation.separator.period";

.fileTypes |= ((. + ["mli", "eliomi"]) | unique)

| .repository."module-names".patterns = [
    {
      "comment": "module type name",
      "match": ("\\b(module)[[:space:]]+(type)[[:space:]]+(?!of\\b)(" + upper + ")"),
      "captures": {
        "1": {"name": "keyword.ocaml"},
        "2": {"name": "keyword.ocaml"},
        "3": {"name": "entity.name.type.interface.ocaml"}
      }
    },
    {
      "comment": "module name after module",
      "match": ("\\b(?:(let)[[:space:]]+)?(module)[[:space:]]+(rec[[:space:]]+)?(?!type\\b)(" + upper + ")"),
      "captures": {
        "1": {"name": "keyword.ocaml"},
        "2": {"name": "keyword.ocaml"},
        "3": {"name": "keyword.ocaml"},
        "4": {"name": "entity.name.namespace.ocaml"}
      }
    },
    {
      "comment": "module path after open or include",
      "match": ("\\b(?:(let)[[:space:]]+)?(open|include)(!?)[[:space:]]+((?:" + upper + "[[:space:]]*\\.[[:space:]]*)*)(" + upper + ")(?![[:space:]]*\\.)"),
      "captures": {
        "1": {"name": "keyword.ocaml"},
        "2": {"name": "keyword.ocaml"},
        "3": {"name": "keyword.ocaml"},
        "4": {"patterns": [{"include": "#identifiers"}]},
        "5": {"name": "entity.name.namespace.ocaml"}
      }
    }
  ]

| .repository.bindings.patterns |= [{"include": "#module-names"}] + map(
    if .comment == "locally abstract types" then .captures."3".name = "entity.name.type.parameter.ocaml" else . end
  )

| .repository.operators.patterns |= [
    {
      "comment": "field access",
      "match": ("(\\.)(" + lower + ")"),
      "captures": {
        "1": {"name": period},
        "2": {"name": "variable.other.property.ocaml"}
      }
    }
  ] + .

| .repository.identifiers.patterns |= [
    {
      "comment": "module path qualifier",
      "match": ("\\b(" + upper + ")[[:space:]]*(\\.)"),
      "captures": {
        "1": {"name": "entity.name.namespace.ocaml"},
        "2": {"name": period}
      }
    }
  ] + map(
    if .comment == "capital identifier for constructor, exception, or module"
    then .comment = "capital identifier for constructor or exception" | .name = "variable.other.enummember.ocaml"
    else . end
  )

| .repository.literals.patterns |= map(
    if .comment == "braces" then .patterns = [
      {
        "comment": "record field name",
        "match": ("(?:(?<=\\{)|(?<=;)|(?<=\\bwith)|^)[[:space:]]*(?:(mutable)[[:space:]]+)?(?!_(?![[:word:]']))(" + lower + ")(?=[[:space:]]*(?:[:;}]|=(?![=>~!?$&*+\\-/@^|%<:.])))"),
        "captures": {
          "1": {"name": "keyword.other.ocaml"},
          "2": {"name": "variable.other.property.ocaml"}
        }
      }
    ] + .patterns else . end
  )
