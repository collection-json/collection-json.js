REPORTER = spec

all: build build-min

test:
	@NODE_ENV=test ./node_modules/.bin/mocha --reporter $(REPORTER)

build:
	@component build --standalone CollectionJSON

build-min:
	@./node_modules/.bin/uglifyjs \
		-o ./build/build.min.js \
		./build/build.js

.PHONY: test build
