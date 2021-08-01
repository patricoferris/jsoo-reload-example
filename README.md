jsoo-reload-example
-------------------

A simple example for [use in a discuss post](https://discuss.ocaml.org/t/jsoo-build-integration-with-js-front-end-project/8226) using dune to enable an easy to way to work with jsoo in a dev environment.

There's a simple jsoo project in `js` which is compiled by this dune file:

<!-- $MDX file=js/dune -->
```
(executable
 (name main)
 (libraries js_of_ocaml)
 (preprocess (pps js_of_ocaml-ppx))
 (modes js))
```

Then over in the website directory there's another dune file with a single rule that depends on the output of the stanza from above:

<!-- $MDX file=site/dune -->
```
(rule
 (deps ../js/main.bc.js)
 (target ./print.js )
 (mode
  (promote (until-clean)))
 (action (copy %{deps} %{target})))
```

It copies the file and automatically promotes it into the site directory when it is different to what is already there. Then there's a normal `index.js` file which uses the code from `print.js` and finally the `index.html` loads the `index.js`. Here I'm then using the bundler [parcel](https://parceljs.org/) because it's the one I know best. The Makefile then uses `npx` and `concurrently` to bundle and build jsoo simultaneously.

<!-- $MDX file=Makefile -->
```
watch:
		npx concurrently --raw "npx parcel watch site/index.html" "dune build -w"

serve:
		dune exec -- ./server/server.exe
```

Running this project with `make watch` will now recompile the jsoo if you change it, which is copied over by `dune` which triggers `parcel` to rebundle.

## One step further

There's also a small [dream](https://github.com/aantron/dream) server that uses a custom [dream-livereload](https://github.com/tmattio/dream-livereload) setup with [irmin-watcher](https://github.com/mirage/irmin-watcher). This setup triggers a client-side refresh of the browser whenever something changes in `dist` (parcel's default output directory). The code is loosely based off of what I use in [current-sesame](https://github.com/patricoferris/sesame). Most people probably already have some livereloading server, but this was useful for testing. You can run `make watch` in one terminal and `make serve` in another, open a browser and the console, then making a change to the jsoo, wait a wee moment and it should refresh with the new code :)
