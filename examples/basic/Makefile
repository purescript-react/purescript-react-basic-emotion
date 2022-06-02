all: node_modules deps
	npx spago bundle-app --main Main --to output/bundle.js
	npx browserify output/bundle.js -o html/index.js

node_modules:
	npm install

deps:
	npx spago install
