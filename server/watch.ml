open Lwt.Infix
let watch f dir =
  let events = ref [] in
  let cond = Lwt_condition.create () in
  Irmin_watcher.hook 0 dir (fun e ->
      events := e :: !events;
      Lwt_condition.broadcast cond ();
      Lwt.return_unit)
  >|= fun _unwatch ->
  let f () =
    let rec aux () : unit Lwt.t =
      Lwt_condition.wait cond >>= fun () ->
      List.iter (fun p -> f p) !events;
      events := [];
      aux ()
    in
    aux ()
  in
  f, cond

let script ~port =
  Fmt.str {|
      var socket = new WebSocket('ws://localhost:%i/websocket');

      socket.onopen = function () {
        socket.send("Reload Me Please!");
      };

      socket.onmessage = function (e) {
        window.location.reload()
      }
  |} port