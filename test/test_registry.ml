let () =
  let all = Tm_grammars.all in
  let count = List.length all in
  Printf.printf "Registry contains %d grammars\n" count;
  if count = 0 then (
    Printf.eprintf "FAIL: Tm_grammars.all is empty\n";
    exit 1
  );
  let available = Tm_grammars.available in
  if List.length available <> count then (
    Printf.eprintf "FAIL: available length (%d) <> all length (%d)\n"
      (List.length available) count;
    exit 1
  );
  let check_find lang =
    match Tm_grammars.find lang with
    | Some json ->
        if String.length json = 0 then (
          Printf.eprintf "FAIL: grammar for '%s' is empty\n" lang;
          exit 1
        );
        Printf.printf "  %-20s  %d bytes\n" lang (String.length json)
    | None ->
        Printf.eprintf "FAIL: Tm_grammars.find \"%s\" returned None\n" lang;
        exit 1
  in
  let spot_checks = [ "ocaml"; "javascript"; "reason"; "json"; "css" ] in
  Printf.printf "Spot-checking %d grammars:\n" (List.length spot_checks);
  List.iter check_find spot_checks;
  (match Tm_grammars.find "this-language-does-not-exist" with
  | Some _ ->
      Printf.eprintf "FAIL: find returned Some for a nonexistent language\n";
      exit 1
  | None -> ());
  Printf.printf "OK\n"
