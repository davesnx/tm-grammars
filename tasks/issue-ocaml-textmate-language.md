# Tokenizer drops opening quote string scope for overlapping begin captures

Target repo: `davesnx/ocaml-textmate-language`

## Summary

When tokenizing shell input through `textmate-language` (used by Ochre), the opening quote of a quoted command argument can miss its `string.*` scope, while the body and closing quote are scoped as string.

This appears to be a tokenizer capture-handling issue (overlapping begin captures), not a grammar source issue.

Related report in grammar package: https://github.com/davesnx/tm-grammars/issues/1

## Reproduction

Use the shell grammar from `tm-grammars` and tokenize:

```sh
printf 'echo "x"\n' | ochre shellscript --stdin --format tokens
```

Observed tokens for the quoted argument include:

```text
{"}[meta.statement.command.name.shell,meta.statement.command.shell,meta.statement.shell,source.shell]
{x}[meta.statement.command.name.continuation string.quoted.double entity.name.function.call entity.name.command,meta.statement.command.name.shell,meta.statement.command.shell,meta.statement.shell,source.shell]
{"}[string.quoted.double.shell punctuation.definition.string.end.shell entity.name.function.call.shell entity.name.command.shell,meta.statement.command.name.shell,meta.statement.command.shell,meta.statement.shell,source.shell]
```

## Observed

- Opening quote lacks `string.*` scope.
- Body has `string.quoted.double`.
- Closing quote has `string.quoted.double.shell`.

## Expected

Opening and closing delimiters should be consistent (both string-scoped, or neither).

## Why this seems tokenizer-related

The current shell grammar rule uses overlapping begin captures on the same char in `command_name_range.patterns[4]`:

- Capture `2`: full quote delimiter group (often empty name)
- Nested capture `3`/`4`: quote-specific begin punctuation + `string.quoted.*`

If overlapping captures with same boundaries are merged/deduped in the wrong order, the nested string capture on the opening quote can be dropped.

Likely place to inspect: capture emission ordering and zero-length/duplicate pruning in `src/tokenizer.ml` (`handle_captures` / `remove_empties`).

## Note

Could not post this directly because `davesnx/ocaml-textmate-language` currently has issues disabled.
