open Js_of_ocaml 

let print s =
  print_endline @@ ("Change me live! " ^ Js.to_string s)

let () =
  Js.export_all
    (object%js
      method print s = print s
     end)