.PHONY: build clean docs install test remake debug

CFLAGS ?= -O3
LDFLAGS ?= -Wl,-O1,--sort-common,-z,relro,-z,combreloc

DEBUG_CFLAGS=-Og -ggdb3
DEBUG_LDFLAGS=-ggdb3

OPT=${CFLAGS}

PYTHON ?= `which python`

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
	${PYTHON} setup.py build

install:
	export CFLAGS="${CFLAGS}"
	export LDFLAGS="${LDFLAGS}"
	${PYTHON} setup.py install

clean:
	cd docs && $(MAKE) $(MFLAGS) clean
	${PYTHON} setup.py clean --all

docs:
	${PYTHON} setup.py --distutils install --install-lib ./docs
	cd docs && $(MAKE) $(MFLAGS) clean
	cd docs && $(MAKE) $(MFLAGS) doctest html
	cd docs/_build/html && zip -r docs.zip *

test: build
	export CFLAGS="${CFLAGS}"
	export LDFLAGS="${LDFLAGS}"
	PYTHONPATH="./tests:${PYTHONPATH}" ${PYTHON} setup.py --distutils install --install-lib ./tests
	${PYTHON} tests/llist_test.py

check: test
