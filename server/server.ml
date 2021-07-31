open Lwt.Infix

(* Livereload based on https://github.com/tmattio/dream-livereload/ *)
let route reload =
  Dream.get "/websocket" (fun _ ->
    Dream.websocket (fun websocket ->
        Dream.receive websocket >>= function
        | Some _ ->
            Lwt_condition.wait reload >>= fun _ ->
            Lwt_unix.sleep 0.2 >>= fun _ ->
            Dream.send websocket "RELOAD" >>= fun () ->
            Dream.close_websocket websocket
        | _ -> Dream.close_websocket websocket))

let server reload =
  Dream.serve ~debug:true
    @@ Dream.logger
    @@ Dream_livereload.inject_script ~script:(Watch.script ~port:8080) ()
    @@ Dream.router
        [ route reload;
          Dream.get "/**" (Dream.static "./dist")
        ]
    @@ Dream.not_found

let () =
  let main () = 
    Watch.watch (fun s -> print_endline s) "./dist" >>= fun (watch, cond) ->
    Lwt.choose [ server cond; watch () ]
  in
  Lwt_main.run @@ main ()