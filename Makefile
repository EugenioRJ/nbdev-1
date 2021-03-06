.ONESHELL:
SHELL := /bin/bash

SRC = $(wildcard nbs/*.ipynb)

all: nbdev docs

nbdev: $(SRC)
	nbdev_build_lib
	touch nbdev

docs_serve: docs
	cd docs && bundle exec jekyll serve

docs: $(SRC)
	nbdev_build_docs
	touch docs

test:
	nbdev_test_nbs

release: pypi tag
	nbdev_conda_package --upload_user fastai
	nbdev_bump_version

tag:
	TAG="$(python setup.py version)"
	git tag "${TAG}"
	git push --tags
	gh api repos/:owner/:repo/releases -F tag_name="${TAG}" -F name="${TAG}"

pypi: dist
	twine upload --repository pypi dist/*

dist: clean
	python setup.py sdist bdist_wheel

clean:
	rm -rf dist

