watch:
		npx concurrently --raw "npx parcel watch site/index.html" "dune build -w"

serve:
		dune exec -- ./server/server.exe