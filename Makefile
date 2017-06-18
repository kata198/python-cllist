.PHONY: build clean docs install test remake debug

CFLAGS ?= -O3
LDFLAGS ?= -Wl,-O1,--sort-common,-z,relro,-z,combreloc

DEBUG_CFLAGS=-Og -ggdb3
DEBUG_LDFLAGS=-ggdb3

OPT=${CFLAGS}

all:
	export CFLAGS="${CFLAGS}"
	export LDFLAGS="${LDFLAGS}"
	export OPT="${OPT}"
	make build

debug:
	export CFLAGS="${DEBUG_CFLAGS}"
	export LDFLAGS="${DEBUG_LDFLAGS}"
	export OPT="${DEBUG_CFLAGS}"
	CFLAGS="-Og" make build

remake:
	export CFLAGS="${CFLAGS}"
	export LDFLAGS="${LDFLAGS}"
	export OPT="${OPT}"
	make clean
	make build

build:
	export CFLAGS="${CFLAGS}"
	export LDFLAGS="${LDFLAGS}"
	export OPT="${OPT}"
	python setup.py build

install:
	export CFLAGS="${CFLAGS}"
	export LDFLAGS="${LDFLAGS}"
	python setup.py install

clean:
	cd docs && $(MAKE) $(MFLAGS) clean
	python setup.py clean --all

docs:
	python setup.py --distutils install --install-lib ./docs
	cd docs && $(MAKE) $(MFLAGS) clean
	cd docs && $(MAKE) $(MFLAGS) doctest html
	cd docs/_build/html && zip -r docs.zip *

test: build
	export CFLAGS="${CFLAGS}"
	export LDFLAGS="${LDFLAGS}"
	PYTHONPATH="./tests:${PYTHONPATH}" python setup.py --distutils install --install-lib ./tests
	python tests/llist_test.py

check: test
