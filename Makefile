.PHONY: build clean docs install test remake

PYTHON ?= `which python`

all:
	make build

remake:
	make clean
	make build

build:
	${PYTHON} setup.py build

install:
	${PYTHON} setup.py install

clean:
	cd docs && $(MAKE) $(MFLAGS) clean
	${PYTHON} setup.py clean --all

docs:
	${PYTHON} setup.py install --install-lib ./docs
	cd docs && $(MAKE) $(MFLAGS) clean
	cd docs && $(MAKE) $(MFLAGS) doctest html
	cd docs/_build/html && zip -r docs.zip *

test: build
	PYTHONPATH="./tests:${PYTHONPATH}" ${PYTHON} setup.py --distutils install --install-lib ./tests
	${PYTHON} tests/llist_test.py

check: test
