import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import oniguruma from "vscode-oniguruma";
import textmate, { type IGrammar } from "vscode-textmate";

type Root = "source.ocaml" | "source.ocaml.interface";
type Case = { readonly code: string; readonly scope: string; readonly root?: Root };

const cases: readonly Case[] = [
  { code: "let n = «String».length s", scope: "entity.name.namespace.ocaml" },
  { code: "let x = Foo.«Bar».baz", scope: "entity.name.namespace.ocaml" },
  { code: "let n = String.«length» s", scope: "source.ocaml" },
  { code: "let x = «Some» 1", scope: "variable.other.enummember.ocaml" },
  { code: "| exception Unix.«Unix_error» _ -> ()", scope: "variable.other.enummember.ocaml" },
  { code: "let b = «true»", scope: "constant.language.boolean.ocaml" },
  { code: "let a = r.«field»", scope: "variable.other.property.ocaml" },
  { code: "let p = { «x» = 1; y = 2 }", scope: "variable.other.property.ocaml" },
  { code: "let p = { x = 1; «y» }", scope: "variable.other.property.ocaml" },
  { code: "let q = { p with «x» = 3 }", scope: "variable.other.property.ocaml" },
  { code: "type t = { mutable «x» : int }", scope: "variable.other.property.ocaml" },
  { code: "let { x; «_» } = p", scope: "constant.language.ocaml" },
  { code: "type «t» = int", scope: "entity.name.type.ocaml" },
  { code: "type 'a «t» = 'a list", scope: "entity.name.type.ocaml" },
  { code: "module «M» = struct end", scope: "entity.name.namespace.ocaml" },
  { code: "let module «M» = Map.Make (String) in ()", scope: "entity.name.namespace.ocaml" },
  { code: "module type «S» = sig end", scope: "entity.name.type.interface.ocaml" },
  { code: "open «Cmdliner»", scope: "entity.name.namespace.ocaml" },
  { code: "open Yojson.Basic.«Util»", scope: "entity.name.namespace.ocaml" },
  { code: "let open «Foo» in x", scope: "entity.name.namespace.ocaml" },
  { code: "include «Base»", scope: "entity.name.namespace.ocaml" },
  { code: "let f (type« a») (x : a) = x", scope: "entity.name.type.parameter.ocaml" },
  { code: "let f «~x» = x", scope: "variable.parameter.labeled.ocaml" },
  { code: "let f «?x» () = x", scope: "variable.parameter.optional.ocaml" },
  { code: "and «g» x = x", scope: "entity.name.function.binding.ocaml" },
  { code: "external «f» : unit -> unit = \"f\"", scope: "entity.name.function.binding.ocaml" },
  { code: "module type S = sig type «t» end", scope: "entity.name.type.ocaml" },
  { code: "module type S = sig module «M» : T end", scope: "entity.name.namespace.ocaml" },
  { code: "type «t» = int", scope: "entity.name.type.ocaml", root: "source.ocaml.interface" },
  { code: "module «M» : sig end", scope: "entity.name.namespace.ocaml", root: "source.ocaml.interface" },
  { code: "module type «S» = sig end", scope: "entity.name.type.interface.ocaml", root: "source.ocaml.interface" },
  { code: "open «Foo»", scope: "entity.name.namespace.ocaml", root: "source.ocaml.interface" },
  { code: "val f : «M».t -> t", scope: "entity.name.namespace.ocaml", root: "source.ocaml.interface" },
];

const vendor = (file: string): string => fileURLToPath(new URL(`../../vendor/${file}`, import.meta.url));

const grammarFiles = new Map<string, string>([
  ["source.ocaml", process.env["OCAML_GRAMMAR"] ?? vendor("ocaml.json")],
]);
const interfaceGrammar = process.env["OCAML_INTERFACE_GRAMMAR"] ?? vendor("ocaml-interface.json");
if (interfaceGrammar !== "") grammarFiles.set("source.ocaml.interface", interfaceGrammar);

const wasm = readFileSync(fileURLToPath(import.meta.resolve("vscode-oniguruma/release/onig.wasm")));
await oniguruma.loadWASM(wasm);

const registry = new textmate.Registry({
  onigLib: Promise.resolve({
    createOnigScanner: (patterns: string[]) => new oniguruma.OnigScanner(patterns),
    createOnigString: (s: string) => new oniguruma.OnigString(s),
  }),
  loadGrammar: async (scopeName: string) => {
    const file = grammarFiles.get(scopeName);
    if (file === undefined) return null;
    return textmate.parseRawGrammar(readFileSync(file, "utf8"), file);
  },
});

const grammars = new Map<Root, IGrammar | string>();
const load = async (root: Root): Promise<IGrammar | string> => {
  try {
    return (await registry.loadGrammar(root)) ?? `${root} grammar did not load`;
  } catch (e) {
    return `${root} grammar did not load: ${String(e)}`;
  }
};
const grammarFor = async (root: Root): Promise<IGrammar | string> => {
  const loaded = grammars.get(root) ?? (await load(root));
  grammars.set(root, loaded);
  return loaded;
};

const scopeOf = async (code: string, root: Root): Promise<string> => {
  const start = code.indexOf("«");
  const end = code.indexOf("»") - 1;
  if (start < 0 || end < start) throw new Error(`case has no «marked» text: ${code}`);
  const grammar = await grammarFor(root);
  if (typeof grammar === "string") return grammar;
  const line = code.replace("«", "").replace("»", "");
  const { tokens } = grammar.tokenizeLine(line, textmate.INITIAL);
  const token = tokens.find((t) => t.startIndex === start && t.endIndex === end);
  if (token !== undefined) return token.scopes.at(-1) ?? "<none>";
  const covering = tokens.find((t) => t.startIndex <= start && start < t.endIndex);
  if (covering === undefined) return "no token";
  return `token «${line.slice(covering.startIndex, covering.endIndex)}»: ${covering.scopes.at(-1) ?? "<none>"}`;
};

let failures = 0;
for (const { code, scope, root = "source.ocaml" } of cases) {
  const actual = await scopeOf(code, root);
  const ok = actual === scope;
  if (!ok) failures += 1;
  const label = root === "source.ocaml" ? code : `${code}  (${root})`;
  console.log(`${ok ? "PASS" : "FAIL"}  ${label}${ok ? "" : `\n      expected ${scope}\n      actual   ${actual}`}`);
}
console.log(`${cases.length - failures}/${cases.length} passed`);
process.exit(failures === 0 ? 0 : 1);
