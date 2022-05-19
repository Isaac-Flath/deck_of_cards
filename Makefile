.ONESHELL:
SHELL := /bin/bash
SRC = $(wildcard nbs/*.ipynb)

nbprocess: $(SRC)
	nbprocess_export
	touch nbprocess

sync:
	nbprocess_update

deploy: docs
	nbprocess_ghp_deploy

serve:
	nbprocess_sidebar
	quarto preview

docs: .FORCE
	nbprocess_export
	pip install -e .
	nbprocess_quarto

test:
	nbdev_test_nbs

release: pypi conda_release
	nbdev_bump_version

conda_release:
	fastrelease_conda_package

pypi: dist
	twine upload --repository pypi dist/*

dist: clean
	python setup.py sdist bdist_wheel

clean:
	rm -rf dist
	

install: install_quarto
	pip install -e .

install_quarto: .FORCE
	./install_quarto.sh

.FORCE:
