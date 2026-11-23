def lower: "[[:lower:]_][[:word:]']*";
def upper: "[[:upper:]][[:word:]']*+";
def period: "keyword.other.ocaml punctuation.other.period punctuation.separator.period";
def record_field: {
  "comment": "record field name",
  "match": ("(?:(?<=\\{)|(?<=;)|(?<=\\bwith)|^)[[:space:]]*(?:(mutable)[[:space:]]+)?(?!_(?![[:word:]']))(" + lower + ")(?=[[:space:]]*(?:[:;}]|=(?![=>~!?$&*+\\-/@^|%<:.])))"),
  "captures": {
    "1": {"name": "keyword.other.ocaml"},
    "2": {"name": "variable.other.property.ocaml"}
  }
};
def module_path: ("(?:" + upper + "[[:space:]]*\\.[[:space:]]*)*" + upper);
def colon: "keyword.other.ocaml punctuation.other.colon punctuation.colon";
def params: "(_[[:space:]]+|[+-]?'[[:alpha:]][[:word:]']*[[:space:]]+|\\([^()]*\\)[[:space:]]+)?";
def type_start: ("(?=(?:private[[:space:]]+)?(?!private\\b)(?:" + lower + "|'|\\(|\\[|" + upper + "[[:space:]]*\\.))");
def type_end: ("(?=[=)\\]};,|]|\\b(?:and|begin|class|constraint|do|done|downto|else|end|exception|external|for|fun|function|if|in|include|inherit|initializer|let|match|method|module|object|open|sig|struct|then|to|try|type(?!(?:[[:space:]]+" + lower + ")+[[:space:]]*\\.)|val|when|while|with)\\b(?!'))");
def item_end: "(?=[)\\]}]|;;|\\[@@@|\\b(?:class|end|exception|external|in|include|inherit|initializer|let|method|module|object|open|sig|struct|type|val)\\b(?!'))";

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
      "comment": "module alias or functor application on one line",
      "match": ("\\b(?:(let)[[:space:]]+)?(module)[[:space:]]+(rec[[:space:]]+)?(?!type\\b)(" + upper + ")[[:space:]]*(=)[[:space:]]*(" + module_path + "(?:[[:space:]]*\\([[:space:]]*" + module_path + "[[:space:]]*\\))*)(?=[[:space:]]*(?:$|\\(\\*|;;|\\bin\\b))"),
      "captures": {
        "1": {"name": "keyword.ocaml"},
        "2": {"name": "keyword.ocaml"},
        "3": {"name": "keyword.ocaml"},
        "4": {"name": "entity.name.namespace.ocaml"},
        "5": {"name": "keyword.operator.ocaml"},
        "6": {"patterns": [{"match": ("\\b" + upper), "name": "entity.name.namespace.ocaml"}, {"match": "\\.", "name": period}]}
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

| .repository."type-expression".patterns = [
    {"include": "#comments"},
    {"include": "#attributes"},
    {"include": "#extensions"},
    {"include": "#strings"},
    {"include": "#characters"},
    {
      "comment": "locally abstract types in a polymorphic annotation",
      "match": ("\\b(type)[[:space:]]+(" + lower + "(?:[[:space:]]+" + lower + ")*)[[:space:]]*(?=\\.)"),
      "captures": {
        "1": {"name": "keyword.ocaml"},
        "2": {"name": "entity.name.type.parameter.ocaml"}
      }
    },
    {
      "comment": "optional argument label",
      "name": "variable.parameter.optional.ocaml",
      "match": ("\\?" + lower + "(?=:(?!:))")
    },
    {
      "comment": "argument label",
      "name": "variable.parameter.labeled.ocaml",
      "match": ("\\b" + lower + "(?=:(?!:))")
    },
    {"begin": "\\(", "end": "\\)", "patterns": [{"include": "#type-expression"}]},
    {"begin": "\\[", "end": "\\]", "patterns": [{"include": "#type-expression"}]},
    {"begin": "\\{", "end": "\\}", "patterns": [record_field, {"include": "#type-annotation"}, {"include": "#type-expression"}]},
    {
      "comment": "module path qualifier",
      "match": ("\\b(" + upper + ")[[:space:]]*(\\.)"),
      "captures": {
        "1": {"name": "entity.name.namespace.ocaml"},
        "2": {"name": period}
      }
    },
    {"include": "#types"},
    {"include": "#keywords"},
    {"comment": "arrow or tuple", "name": "keyword.operator.ocaml", "match": "->|\\*"},
    {"comment": "coercion", "name": colon, "match": ":>"},
    {"comment": "label colon", "name": colon, "match": ":"},
    {"comment": "polymorphic variant tag", "name": "constant.language.polymorphic-variant.ocaml", "match": "\\`[[:alpha:]][[:word:]']*\\b"},
    {"comment": "wildcard", "name": "constant.language.ocaml", "match": "\\b_\\b"},
    {"comment": "module type name", "name": "entity.name.type.interface.ocaml", "match": ("\\b" + upper)},
    {"comment": "type constructor", "name": "entity.name.type.ocaml", "match": ("\\b" + lower)}
  ]

| .repository."type-annotation".patterns = [
    {
      "comment": "type annotation or coercion",
      "begin": "(?<=[[:space:]])(:>?)(?=[[:space:]]|$)",
      "beginCaptures": {"1": {"name": colon}},
      "end": type_end,
      "patterns": [{"include": "#type-expression"}]
    },
    {
      "comment": "constructor arguments",
      "begin": "(?<!\\btype[[:space:]])\\b(of)\\b(?!')",
      "beginCaptures": {"1": {"name": "keyword.other.ocaml"}},
      "end": type_end,
      "patterns": [{"include": "#type-expression"}]
    }
  ]

| .repository."type-definition".patterns = [
    {
      "comment": "type definition",
      "begin": ("\\b(type)[[:space:]]+(nonrec[[:space:]]+)?" + params + "(" + lower + ")"),
      "beginCaptures": {
        "1": {"name": "keyword.ocaml"},
        "2": {"name": "keyword.ocaml"},
        "3": {"patterns": [{"include": "#type-expression"}]},
        "4": {"name": "entity.name.type.ocaml"}
      },
      "end": item_end,
      "patterns": [
        {
          "comment": "type abbreviation",
          "begin": ("(?<!\\+)(:?=)[[:space:]]*" + type_start),
          "beginCaptures": {"1": {"name": "keyword.operator.ocaml"}},
          "end": type_end,
          "patterns": [{"include": "#type-expression"}]
        },
        {
          "comment": "and type definition",
          "match": ("\\b(and)[[:space:]]+(nonrec[[:space:]]+)?" + params + "(" + lower + ")"),
          "captures": {
            "1": {"name": "keyword.ocaml"},
            "2": {"name": "keyword.ocaml"},
            "3": {"patterns": [{"include": "#type-expression"}]},
            "4": {"name": "entity.name.type.ocaml"}
          }
        },
        {"include": "$base"}
      ]
    }
  ]

| .repository.bindings.patterns |= [{"include": "#module-names"}, {"include": "#type-definition"}, {"include": "#type-annotation"}] + map(
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
    if .comment == "braces" then .patterns = [record_field] + .patterns else . end
  )
