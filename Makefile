# Copyright 2020 seL4 Project a Series of LF Projects, LLC.
# SPDX-License-Identifier: BSD-2-Clause

.PHONY: default
default: help

.PHONY: help
help:
	@echo "Makefile for the seL4 docsite"
	@echo "Available targets:"
	@echo "  serve                    - Serve a preview the site locally using Jekyll"
	@echo "  build                    - Build the site for production in _site"
	@echo "  preview                  - Build the site for externally hosted preview in _preview"
	@echo "  docker_serve             - Serve a preview of the site using Docker"
	@echo "  docker_build             - Build the site using Docker"
	@echo "  check_conformance_errors - Check for conformance and show errors"
	@echo "  check_liquid_syntax      - Check the liquid syntax of the templates"
	@echo "  check_html_output        - Check the HTML output using tidy"

.PHONY: ruby_deps
ruby_deps: .jekyll-cache/ruby_deps

.jekyll-cache/ruby_deps: Gemfile Gemfile.lock
	bundle install
	@mkdir -p .jekyll-cache/
	@touch $@

.npm_deps: package.json package-lock.json
	npm install
	@touch $@

# The following rules generate a yaml file that contains file modification metadata
# provided by git.  The format is:
#
# date: Tue Mar 13 19:11:51 2018 +1100
# timestamps:
#   - page: BuildSystemAnatomy/index.md
#     date: Tue Mar 13 19:11:51 2018 +1100
#   - page: CAmkESDifferences.md
#     date: Tue Mar 13 19:11:51 2018 +1100
# ...
# If this prebuild _data generation step gets more complicated then it should
# probably be moved to a python script.

FILE_NAME=_data/generated.yml

UPDATE_DATE:= $(shell git log -1 --format='%cd %h')
FILES:= $(shell find . -iname "*.md" | grep -ve "./README.md" | grep -ve "^./_repos/"| sed 's/.\///')

.PHONY: _data/generated.yml
_data/generated.yml:
	echo "date: $(UPDATE_DATE)" > $(FILE_NAME)
	echo timestamps: >> $(FILE_NAME) && \
	for i in $(FILES); do \
		echo "  - page: $$i" >> $(FILE_NAME) &&\
		echo "    date: `git log -1 --format='%cd %h' -- $$i`" >> $(FILE_NAME); \
	done

.PHONY: generate_data_files
generate_data_files: _data/generated.yml

# Adding a git URL here and appending the directory name to REPOSITORY_LIST will
# add a rule for checking out the repository under _repos/$(REPO_NAME)
GIT_REPOS:=$(shell (cd _data/projects && for i in `ls`; do cat $$i | ../../tools/get_repos.py ; done) | sort -u)
REPOSITORY_LIST = sel4 sel4-tutorials capdl
REPOSITORIES = $(GIT_REPOS:%=_repos/%)

$(REPOSITORIES):
	mkdir -p $@
	git clone --depth=1 https://github.com/$(@:_repos/%=%) $@

TUTES_DST = _processed/tutes
TUTES_REPO = _repos/sel4proj/sel4-tutorials

$(TUTES_DST):
	mkdir -p $@

$(TUTES_DST)/%.md: $(TUTES_REPO)/tutorials/*/%.md
	@echo "$<  ==>  $@"
	@PYTHONPATH=_repos/sel4/capdl/python-capdl-tool \
	$(TUTES_REPO)/template.py --docsite --out-dir $(TUTES_DST) --tut-file $<

# Make tutorials
# Filter out index.md; get-the-tutorials.md; how-to.md pathways.md; setting-up.md
# which are docsite pages, and not in the tutorials repo
TUTORIALS:= $(filter-out index.md get-the-tutorials.md how-to.md pathways.md setting-up.md seL4-end.md,$(notdir $(wildcard Tutorials/*.md)))
tutorials: $(TUTES_DST) ${TUTORIALS:%=$(TUTES_DST)/%}

PROCESS_MDBOOK = tools/process-mdbook.py
MICROKIT_TUT_DST = _processed/microkit-tutorial
MICROKIT_TUT_SRC = _repos/au-ts/microkit_tutorial/website/src
MICROKIT_TUT_SRC_FILES = $(wildcard $(MICROKIT_TUT_SRC)/*.md)
MICROKIT_TUT_DST_FILES = $(patsubst $(MICROKIT_TUT_SRC)/%, $(MICROKIT_TUT_DST)/%, $(MICROKIT_TUT_SRC_FILES))

$(MICROKIT_TUT_DST)/%.md: $(MICROKIT_TUT_SRC)/%.md
	@echo "$<  ==>  $@"
	@$(PROCESS_MDBOOK) $< $(dir $@)

_data/microkit_tutorial.yml: $(MICROKIT_TUT_SRC)/../build.sh
	@tools/mk_tutorial_vars.sh $< $@

.PHONY: microkit-tutorial
microkit-tutorial: $(MICROKIT_TUT_DST_FILES) _data/microkit_tutorial.yml

.PHONY: _generate_api_pages
_generate_api_pages: $(REPOSITORIES)
	$(MAKE) markdown -C _repos/sel4/sel4/manual

LIBSEL4VM_SRC = _repos/sel4proj/sel4_projects_libs/libsel4vm/docs
LIBSEL4VM_DST = projects/virtualization/docs/api
LIBSEL4VM_SRC_FILES = $(wildcard $(LIBSEL4VM_SRC)/libsel4vm_*.md)
LIBSEL4VM_DST_FILES = $(patsubst $(LIBSEL4VM_SRC)/%, $(LIBSEL4VM_DST)/%, $(LIBSEL4VM_SRC_FILES))

$(LIBSEL4VM_DST)/%.md: $(LIBSEL4VM_SRC)/%.md
	@echo "$<  ==>  $@"
	@tools/gen_markdown_api_doc.py -f $< -o $@ -p libsel4vm.html

$(LIBSEL4VM_DST):
	mkdir -p $(LIBSEL4VM_DST)

# same destination dir as libsel4vm
LIBSEL4VMM_SRC = _repos/sel4proj/sel4_projects_libs/libsel4vmmplatsupport/docs
LIBSEL4VMM_SRC_FILES = $(wildcard $(LIBSEL4VMM_SRC)/libsel4vmmplatsupport_*.md)
LIBSEL4VMM_DST_FILES = $(patsubst $(LIBSEL4VMM_SRC)/%, $(LIBSEL4VM_DST)/%, $(LIBSEL4VMM_SRC_FILES))

$(LIBSEL4VM_DST)/%.md: $(LIBSEL4VMM_SRC)/%.md
	@echo "$<  ==>  $@"
	@tools/gen_markdown_api_doc.py -f $< -o $@ -p libsel4vmm.html

.PHONY: generate_libsel4vm_api
generate_libsel4vm_api: $(REPOSITORIES) $(LIBSEL4VM_DST) $(LIBSEL4VM_DST_FILES)

.PHONY: generate_libsel4vmmplatsupport_api
generate_libsel4vmmplatsupport_api: $(REPOSITORIES) $(LIBSEL4VM_DST) $(LIBSEL4VMM_DST_FILES)

.PHONY: generate_api
generate_api: _generate_api_pages generate_libsel4vm_api generate_libsel4vmmplatsupport_api

# Rules for local serving of the site using jekyll.
# Supports docker or running using local environment.
# The _production versions run with JEKYLL_ENV=production which will show additional content.
# The _production versions require `generate_data_files` to have been run separately.
JEKYLL_ENV:=development
DOCKER_IMG:=docs_builder
.PHONY: docker_serve
docker_serve: docker_build
	docker run -p 4000:4000 -v $(PWD):/docs -w /docs -it $(DOCKER_IMG) bash -c 'make serve JEKYLL_ENV=$(JEKYLL_ENV)'

.PHONY: docker_build
docker_build:
	docker build -t $(DOCKER_IMG) tools/

# --host 0.0.0.0 serves on all interfaces, so that docker can export
# the connection; also works locally
.PHONY: serve
serve: generate
	JEKYLL_ENV=$(JEKYLL_ENV) bundle exec jekyll serve

.PHONY: generate
generate: generate_api ruby_deps .npm_deps microkit-tutorial tutorials $(REPOSITORIES)
ifeq ($(JEKYLL_ENV),production)
	$(MAKE) generate_data_files
endif

.PHONY: build
build: generate
	JEKYLL_ENV=$(JEKYLL_ENV) bundle exec jekyll build $(BUILD_OPTS)

.PHONY: preview
preview: JEKYLL_ENV := production
preview: BUILD_OPTS := --config "_config.yml,_preview.yml" $(BUILD_OPTS)
preview: build

.PHONY: clean
clean:
	rm -rf _site
	rm -rf _preview
	rm -rf _data/generated.yml
	rm -rf _processed/microkit-tutorial
	rm -rf _processed/tutes
	rm -rf projects/virtualization/docs/api
	rm -f _data/microkit_tutorial.yml

.PHONY: repoclean
repoclean: clean
	rm -rf _repos

# Check conformance for Web Content Accessibility Guidelines (WCAG) 2.0, AA
# This relies on Automated Accessibility Testing Tool (AATT) (https://github.com/paypal/AATT)
# to be running and listening on http://localhose:3000
# The resulting conformance_results.xml file can be viewed with `make check_conformance_errors` or using a junit xml viewer
.PHONY: check_conformance
check_conformance: build
	find _site -iname "*.html"| sed "s/_site.//" | python tools/testWCAG.py > conformance_results.xml

.PHONY: check_conformance_errors
check_conformance_errors: conformance_results.xml
	grep -B1 'type="failure"' conformance_results.xml || true

LIQUID_CUSTOM_TAGS := continue

LIQUID_LINTER_CMDLINE := liquid-linter $(LIQUID_CUSTOM_TAGS:%=--custom-tag %)

# Liquid syntax linting check.
# If it is complaining about unknown custom tags -> add them to the list above.
# Requires `liquid-linter` to be installed.
# git ls-files won't list any files that are untracked
.PHONY: check_liquid_syntax
check_liquid_syntax:
	git ls-files "*.html" | xargs $(LIQUID_LINTER_CMDLINE)
	git ls-files "*.md" | xargs $(LIQUID_LINTER_CMDLINE)

# Output html checking using tidy.
# Any warnings or errors will be printed to stdout
# Requires `tidy` to be installed.
.PHONY: check_html_output
check_html_output: build
	find _site/ -iname "*.html"| xargs -l tidy -q --drop-empty-elements n -e
