import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import oniguruma from "vscode-oniguruma";
import textmate, { type IGrammar } from "vscode-textmate";

type Root = "source.ocaml" | "source.ocaml.interface" | "source.ocaml.mlx";
type Case = { readonly code: string; readonly scope: string; readonly root?: Root };

const ocamlCases: readonly Case[] = [
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
  { code: "module M = «N»", scope: "entity.name.namespace.ocaml" },
  { code: "module M = Map.«Make» (Int)", scope: "entity.name.namespace.ocaml" },
  { code: "module M = Map.Make («Int»)", scope: "entity.name.namespace.ocaml" },
  { code: "let module M = Set.Make («String») in ()", scope: "entity.name.namespace.ocaml" },
  { code: "let module M = «F» (struct end) in ()", scope: "entity.name.namespace.ocaml" },
  { code: "let module M = «F» (struct\n  let x = 1\nend) in ()", scope: "entity.name.namespace.ocaml" },
  { code: "module M = «F» (struct let x = 1 end)", scope: "entity.name.namespace.ocaml" },
  { code: "let x = «A» (b)", scope: "variable.other.enummember.ocaml" },
  { code: "let x = «Some» (struct_like)", scope: "variable.other.enummember.ocaml" },
  { code: "let x : «t» = f y", scope: "entity.name.type.ocaml" },
  { code: "let x : int «option» = None", scope: "entity.name.type.ocaml" },
  { code: "let f (x : M.«t») = x", scope: "entity.name.type.ocaml" },
  { code: "let f (x : «M».t) = x", scope: "entity.name.namespace.ocaml" },
  { code: "let f ~(x : «t») y = y", scope: "entity.name.type.ocaml" },
  { code: "let c = (x :> «t»)", scope: "entity.name.type.ocaml" },
  { code: "let f : type «a». a -> a = fun x -> x", scope: "entity.name.type.parameter.ocaml" },
  { code: "let f : type a. a -> «t» = g", scope: "entity.name.type.ocaml" },
  { code: "type t = { a : «u»; b : int }", scope: "entity.name.type.ocaml" },
  { code: "type t = Foo of { «a» : int }", scope: "variable.other.property.ocaml" },
  { code: "type t = A of M.«u» | B", scope: "entity.name.type.ocaml" },
  { code: "exception E of «t»", scope: "entity.name.type.ocaml" },
  { code: "type t = «u»", scope: "entity.name.type.ocaml" },
  { code: "type t = M.«u»", scope: "entity.name.type.ocaml" },
  { code: "type 'a t = 'a «list»", scope: "entity.name.type.ocaml" },
  { code: "type t = private «u»", scope: "entity.name.type.ocaml" },
  { code: "type t = int and «u» = string", scope: "entity.name.type.ocaml" },
  { code: "type t = int and u = «v»", scope: "entity.name.type.ocaml" },
  { code: "type t = int\nand «u» = A", scope: "entity.name.type.ocaml" },
  { code: "type t =\n  | A : int -> «t»", scope: "entity.name.type.ocaml" },
  { code: "val x : «t»", scope: "entity.name.type.ocaml", root: "source.ocaml.interface" },
  { code: "val f : «x»:int -> unit", scope: "variable.parameter.labeled.ocaml", root: "source.ocaml.interface" },
  { code: "val f : «?x»:int -> unit", scope: "variable.parameter.optional.ocaml", root: "source.ocaml.interface" },
  { code: "type t += M.«C» of int", scope: "variable.other.enummember.ocaml" },
  { code: "let x : int = «f» y", scope: "source.ocaml" },
  { code: "let z = (x : t) + «y»", scope: "source.ocaml" },
  { code: "let f ~(x : int) «y» = y", scope: "source.ocaml" },
  { code: "let x :\n  int =\n  «g» 1", scope: "source.ocaml" },
  { code: "let r = { a : int; b = «c» }", scope: "source.ocaml" },
  { code: "let l = x :: «y»", scope: "source.ocaml" },
  { code: "let a = if b then (c : int) else «d»", scope: "source.ocaml" },
  { code: "let v = match x with A -> (y : int) | «B» -> 0", scope: "variable.other.enummember.ocaml" },
  { code: "type t = A | «B»", scope: "variable.other.enummember.ocaml" },
  { code: "type t = int\nlet «v» = w", scope: "entity.name.function.binding.ocaml" },
  { code: "type t = int\nlet v = «w»", scope: "source.ocaml" },
  { code: "exception E of string\nlet f x = «x»", scope: "source.ocaml" },
  { code: "val f : t\nval «g» : u", scope: "entity.name.function.binding.ocaml", root: "source.ocaml.interface" },
  { code: "type t = { «field» : int } and u = string", scope: "variable.other.property.ocaml", root: "source.ocaml.interface" },
  { code: "type t = { field : int } and «u» = string", scope: "entity.name.type.ocaml", root: "source.ocaml.interface" },
  { code: "type t = {\n  «a» : int;\n  b : string;\n}", scope: "variable.other.property.ocaml", root: "source.ocaml.interface" },
  { code: "type t = {\n  a : int;\n  b : «u»;\n}", scope: "entity.name.type.ocaml", root: "source.ocaml.interface" },
  { code: "type t = {\n  a : int;\n}\nand «u» = string", scope: "entity.name.type.ocaml", root: "source.ocaml.interface" },
  { code: "type t = { mutable «f» : t }", scope: "variable.other.property.ocaml", root: "source.ocaml.interface" },
  { code: "type t = { «mutable» f : t }", scope: "keyword.other.ocaml", root: "source.ocaml.interface" },
  { code: "type t = { a : int«;» b : u }", scope: "punctuation.separator.semicolon", root: "source.ocaml.interface" },
  { code: "type t = { «field» : int } and u = string", scope: "variable.other.property.ocaml" },
  { code: "type t = { field : int } and «u» = string", scope: "entity.name.type.ocaml" },
  { code: "type t = {\n  «a» : int;\n  b : string;\n}", scope: "variable.other.property.ocaml" },
  { code: "type t = {\n  a : int;\n  b : «u»;\n}", scope: "entity.name.type.ocaml" },
  { code: "type t = {\n  a : int;\n}\nand «u» = string", scope: "entity.name.type.ocaml" },
  { code: "type t = { mutable «f» : t }", scope: "variable.other.property.ocaml" },
  { code: "type t = { «mutable» f : t }", scope: "keyword.other.ocaml" },
  { code: "type t = { a : int«;» b : u }", scope: "punctuation.separator.semicolon" },
  { code: "module type S = sig\n  type t = { «f» : int }\n  val x : t\nend", scope: "variable.other.property.ocaml", root: "source.ocaml.interface" },
  { code: "type t = { f : int }\nval «x» : t", scope: "entity.name.function.binding.ocaml", root: "source.ocaml.interface" },
];

const mlx: Root = "source.ocaml.mlx";
const mlxCases: readonly Case[] = [
  { code: "let x = <«div» />", scope: "entity.name.tag.inline.any.html", root: mlx },
  { code: "let x = <«Foo» />", scope: "entity.name.tag.inline.any.html", root: mlx },
  { code: "let x = <«Foo».Bar />", scope: "entity.name.namespace.ocaml", root: mlx },
  { code: "let x = <A.«B».c />", scope: "entity.name.namespace.ocaml", root: mlx },
  { code: "let x = <Foo.«Bar» />", scope: "entity.name.tag.inline.any.html", root: mlx },
  { code: "let x = <Ui.«button» />", scope: "entity.name.tag.inline.any.html", root: mlx },
  { code: "let x = <Foo.Bar>a</«Foo».Bar>", scope: "entity.name.namespace.ocaml", root: mlx },
  { code: "let x = <Foo.Bar>a</Foo.«Bar»>", scope: "entity.name.tag.inline.any.html", root: mlx },
  { code: "let x = <«Foo»>a</Foo>", scope: "entity.name.tag.inline.any.html", root: mlx },
  { code: "let x = <Foo>a</«Foo»>", scope: "entity.name.tag.inline.any.html", root: mlx },
  { code: "let x = (<«div» />)", scope: "entity.name.tag.inline.any.html", root: mlx },
  { code: "let l = [<«li»>\"a\"</li>]", scope: "entity.name.tag.inline.any.html", root: mlx },
  { code: "let x = <div «className»=\"x\" />", scope: "entity.other.attribute-name.namespace.js", root: mlx },
  { code: "let x = <input «value» ?placeholder />", scope: "entity.other.attribute-name.namespace.js", root: mlx },
  { code: "let x = <div className=\"«x»\" />", scope: "string.quoted.double.ocaml", root: mlx },
  { code: "let x = <div n=«1» />", scope: "constant.numeric.decimal.integer.ocaml", root: mlx },
  { code: "let x = <div n=«M».x />", scope: "entity.name.namespace.ocaml", root: mlx },
  { code: "let x = <div n=r.«f» />", scope: "variable.other.property.ocaml", root: mlx },
  { code: "let x = <div f=(x : «t») />", scope: "entity.name.type.ocaml", root: mlx },
  { code: "let x = <div f=(fun _ -> «go» ()) />", scope: "source.ocaml", root: mlx },
  { code: "let x = <Foo p={«a» = 1} />", scope: "variable.other.property.ocaml", root: mlx },
  { code: "let x = <p>«hi»</p>", scope: "source.ocaml", root: mlx },
  { code: "let x = <p>\"«Total»\"</p>", scope: "string.quoted.double.ocaml", root: mlx },
  { code: "let x = <p>(«String».length s)</p>", scope: "entity.name.namespace.ocaml", root: mlx },
  { code: "let x = <p>(String.«length» s)</p>", scope: "source.ocaml", root: mlx },
  { code: "let x = <p>(«Some» 1)</p>", scope: "variable.other.enummember.ocaml", root: mlx },
  { code: "let x = <p>r.«f»</p>", scope: "variable.other.property.ocaml", root: mlx },
  { code: "let x = <p>{«a» = 1}</p>", scope: "variable.other.property.ocaml", root: mlx },
  { code: "let b = a «<» b", scope: "keyword.operator.ocaml", root: mlx },
];

const cases: readonly Case[] = [
  ...ocamlCases,
  ...ocamlCases.filter((c) => c.root === undefined).map((c) => ({ ...c, root: mlx })),
  ...mlxCases,
];

const vendor = (file: string): string => fileURLToPath(new URL(`../../vendor/${file}`, import.meta.url));

const grammarFiles = new Map<string, string>([
  ["source.ocaml", process.env["OCAML_GRAMMAR"] ?? vendor("ocaml.json")],
]);
const interfaceGrammar = process.env["OCAML_INTERFACE_GRAMMAR"] ?? vendor("ocaml-interface.json");
if (interfaceGrammar !== "") grammarFiles.set("source.ocaml.interface", interfaceGrammar);
grammarFiles.set("source.ocaml.mlx", process.env["MLX_GRAMMAR"] ?? vendor("mlx.json"));

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
  const lines = code.split("\n");
  const markedLine = lines.findIndex((l) => l.includes("«"));
  const marked = lines[markedLine] ?? "";
  const start = marked.indexOf("«");
  const end = marked.indexOf("»") - 1;
  if (start < 0 || end < start) throw new Error(`case has no «marked» text on one line: ${code}`);
  const grammar = await grammarFor(root);
  if (typeof grammar === "string") return grammar;
  let state = textmate.INITIAL;
  for (const before of lines.slice(0, markedLine)) state = grammar.tokenizeLine(before, state).ruleStack;
  const line = marked.replace("«", "").replace("»", "");
  const { tokens } = grammar.tokenizeLine(line, state);
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
