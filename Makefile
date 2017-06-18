.PHONY: build clean docs install test remake

all:
	make build

remake:
	make clean
	make build

build:
	python setup.py build

install:
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
	PYTHONPATH="./tests:${PYTHONPATH}" python setup.py --distutils install --install-lib ./tests
	python tests/llist_test.py

check: test
