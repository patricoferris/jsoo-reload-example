(lang dune 2.8)
(using mdx 0.1)

(generate_opam_files true)

(package
 (name jsoo-reload-example)
 (synopsis "simple jsoo example with reloading/rebuilding")
 (depends 
   js_of_ocaml
   js_of_ocaml-ppx
   dream
   dream-livereload
   irmin-watcher))