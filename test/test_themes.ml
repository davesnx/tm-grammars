let fail fmt = Printf.ksprintf (fun msg -> prerr_endline ("FAIL: " ^ msg); exit 1) fmt

let vendored dir =
  Sys.readdir dir |> Array.to_list
  |> List.filter_map (fun file -> Filename.chop_suffix_opt ~suffix:".json" file)
  |> List.sort String.compare

let contains ~sub s =
  let n = String.length sub in
  let rec go i = i + n <= String.length s && (String.sub s i n = sub || go (i + 1)) in
  go 0

let () =
  let expected = vendored Sys.argv.(1) in
  if expected = [] then fail "no vendored themes in %s" Sys.argv.(1);
  let available = List.sort String.compare Tm_themes.available in
  List.iter
    (fun id -> if not (List.mem id available) then fail "theme %s is missing from Tm_themes.all" id)
    expected;
  if List.length Tm_themes.all <> List.length expected then
    fail "Tm_themes.all has %d entries, expected %d" (List.length Tm_themes.all) (List.length expected);
  (match Tm_themes.find "nord" with
  | Some json when contains ~sub:{|"name": "nord"|} json -> ()
  | Some _ -> fail {|find "nord" returned JSON whose "name" is not "nord"|}
  | None -> fail {|find "nord" returned None|});
  if Tm_themes.find "this-theme-does-not-exist" <> None then fail "find returned Some for a missing theme";
  Printf.printf "OK: %d themes\n" (List.length expected)
