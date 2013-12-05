# usage:
# `make` or `make test` runs all the tests
# `make successful_run` runs just that test

TESTS=$(shell cd test && ls *.coffee | sed s/\.coffee$$//)

all: test

test: $(TESTS)

.PHONY: test $(TESTS)

$(TESTS):
	node_modules/mocha/bin/mocha --timeout 60000 --ignore-leaks --compilers coffee:coffee-script --bail test/$@.coffee
