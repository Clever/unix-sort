# usage:
# `make build` or `make` compiles lib/*.coffee to lib/*.js (for all changed lib/*.coffee)
# `make lib/some_file.coffee` compiles just that file to lib-js
# `make test` runs all the tests
# `make some_file` runs just the test `test/some_file.coffee`
.PHONY: test test-cov
TESTS=$(shell cd test && ls *.coffee | sed s/\.coffee$$//)
LIBS=$(shell find . -regex "^./lib\/.*\.coffee\$$" | sed s/\.coffee$$/\.js/ | sed s/lib/lib-js/)

build: $(LIBS)

lib-js/%.js : lib/%.coffee
	node_modules/coffee-script/bin/coffee --bare -c -o $(@D) $(patsubst lib-js/%,lib/%,$(patsubst %.js,%.coffee,$@))

test: $(TESTS)

$(TESTS): build
	DEBUG=* NODE_ENV=test node_modules/mocha/bin/mocha --timeout 60000 --compilers coffee:coffee-script test/$@.coffee

test-cov: build
	# jscoverage only accepts directory arguments so have to rebuild everything
	rm -rf lib-js-cov
	jscoverage lib-js lib-js-cov
	NODE_ENV=test TEST_COV=1 node_modules/mocha/bin/mocha --compilers coffee:coffee-script -R html-cov test/*.coffee | tee coverage.html
	open coverage.html

clean:
	rm -rf lib-js lib-js-cov
