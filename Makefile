# Copyright 2020 seL4 Project a Series of LF Projects, LLC.
# SPDX-License-Identifier: BSD-2-Clause

.PHONY: default
default: help

.PHONY: help
help:
	@echo "Makefile for the seL4 docsite"
	@echo "Useful targets:"
	@echo "  serve                    - Serve a preview the site locally using Jekyll"
	@echo "  build                    - Build the site for production in _site"
	@echo "  preview                  - Build the site for externally hosted preview in _preview"
	@echo "  docker_serve             - Serve a preview of the site using Docker"
	@echo "  docker_build             - Build the site using Docker"
	@echo "  check_conformance_errors - Check for conformance and show errors"
	@echo "  check_liquid_syntax      - Check the liquid syntax of the templates"
	@echo "  check_html_output        - Check the HTML output using tidy"
	@echo "  checklinks               - Runs html-proofer to check for broken links."
	@echo "  validate                 - Runs html5validator to check for HTML5 compliance."

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

GIT_REPOS:=$(shell (cd _data/projects && for i in `ls *.yml`; do cat $$i | ../../tools/get_repos.py ; done) | sort -u)
REPOSITORIES = $(GIT_REPOS:%=_repos/%)

$(REPOSITORIES):
	mkdir -p $@
	git clone --depth=1 --recursive https://github.com/$(@:_repos/%=%) $@

.PHONY: repos
repos: $(REPOSITORIES)

# Microkit

MICROKIT_REPO = _repos/sel4/microkit
$(MICROKIT_REPO)/platforms.yml: $(MICROKIT_REPO)

_data/microkit_platforms.yml: $(MICROKIT_REPO)/platforms.yml
	cp $< $@

.PHONY: microkit
microkit: _data/microkit_platforms.yml

# Tutorials

TUTES_DST = _processed/tutes
TUTES_REPO = _repos/sel4/sel4-tutorials
TUTES_SRC = $(TUTES_REPO)/tutorials

$(TUTES_DST):
	mkdir -p $@

TUTORIAL_FILES := \
	hello-world \
	capabilities \
	untyped \
	ipc \
	interrupts \
	mapping \
	threads \
	notifications \
	mcs \
	fault-handlers \
	hello-camkes-0 \
	hello-camkes-1 \
	hello-camkes-2 \
	hello-camkes-timer \
	camkes-vm-crossvm \
	camkes-vm-linux \
	libraries-1 \
	libraries-2 \
	libraries-3 \
	libraries-4

$(TUTES_DST)/hello-world.md: $(TUTES_SRC)/hello-world/hello-world.md
$(TUTES_DST)/capabilities.md: $(TUTES_SRC)/capabilities/capabilities.md
$(TUTES_DST)/untyped.md: $(TUTES_SRC)/untyped/untyped.md
$(TUTES_DST)/ipc.md: $(TUTES_SRC)/ipc/ipc.md
$(TUTES_DST)/mapping.md: $(TUTES_SRC)/mapping/mapping.md
$(TUTES_DST)/threads.md: $(TUTES_SRC)/threads/threads.md
$(TUTES_DST)/notifications.md: $(TUTES_SRC)/notifications/notifications.md
$(TUTES_DST)/mcs.md: $(TUTES_SRC)/mcs/mcs.md
$(TUTES_DST)/fault-handlers.md: $(TUTES_SRC)/fault-handlers/fault-handlers.md
$(TUTES_DST)/hello-camkes-0.md: $(TUTES_SRC)/hello-camkes-0/hello-camkes-0.md
$(TUTES_DST)/hello-camkes-1.md: $(TUTES_SRC)/hello-camkes-1/hello-camkes-1.md
$(TUTES_DST)/hello-camkes-2.md: $(TUTES_SRC)/hello-camkes-2/hello-camkes-2.md
$(TUTES_DST)/hello-camkes-timer.md: $(TUTES_SRC)/hello-camkes-timer/hello-camkes-timer.md
$(TUTES_DST)/camkes-vm-crossvm.md: $(TUTES_SRC)/camkes-vm-crossvm/camkes-vm-crossvm.md
$(TUTES_DST)/camkes-vm-linux.md: $(TUTES_SRC)/camkes-vm-linux/camkes-vm-linux.md
$(TUTES_DST)/interrupts.md: $(TUTES_SRC)/interrupts/interrupts.md
$(TUTES_DST)/libraries-1.md: $(TUTES_SRC)/libraries-1/libraries-1.md
$(TUTES_DST)/libraries-2.md: $(TUTES_SRC)/libraries-2/libraries-2.md
$(TUTES_DST)/libraries-3.md: $(TUTES_SRC)/libraries-3/libraries-3.md
$(TUTES_DST)/libraries-4.md: $(TUTES_SRC)/libraries-4/libraries-4.md

TUTORIALS := $(TUTORIAL_FILES:%=$(TUTES_DST)/%.md)
$(TUTORIALS):
	@if [ -z "$<" ]; then echo "No dependency specified for $@"; exit 1; fi
	@echo "$<  ==>  $@"
	@PYTHONPATH=_repos/sel4/capdl/python-capdl-tool \
	  $(TUTES_REPO)/template.py --docsite --out-dir $(TUTES_DST) --tut-file $<

.PHONY: tutorials
tutorials: $(TUTES_DST) $(TUTORIALS)

PROCESS_MDBOOK = tools/process-mdbook.py
MICROKIT_TUT_DST = _processed/microkit-tutorial
MICROKIT_TUT_DOC = projects/microkit/tutorial
MICROKIT_TUT_REPO = _repos/au-ts/microkit_tutorial
MICROKIT_TUT_SRC = $(MICROKIT_TUT_REPO)/website/src
# wildcard on files in this repo under projects/microkit to avoid empty wildcard
# when _repos does not exist yet
MICROKIT_TUT_DOC_FILES = $(wildcard $(MICROKIT_TUT_DOC)/*.md)
MICROKIT_TUT_SRC_FILES = $(patsubst $(MICROKIT_TUT_DOC)/%, $(MICROKIT_TUT_SRC)/%, $(MICROKIT_TUT_DOC_FILES))
MICROKIT_TUT_DST_FILES = $(patsubst $(MICROKIT_TUT_DOC)/%, $(MICROKIT_TUT_DST)/%, $(MICROKIT_TUT_DOC_FILES))

# Make sure `make` knows how to build $(MICROKIT_TUT_DST)/%.md if _repos does not exist yet.
# It is not enough for the repos to be cloned before the rule fires -- the implicit rule will only
# fire if it has a complete path to the source when the Makefile is first invoked.
$(MICROKIT_TUT_SRC_FILES) $(MICROKIT_TUT_SRC)/../build.sh: $(MICROKIT_TUT_REPO)

$(MICROKIT_TUT_DST)/%.md: $(MICROKIT_TUT_SRC)/%.md
	@echo "$<  ==>  $@"
	@$(PROCESS_MDBOOK) $< $(dir $@)

_data/microkit_tutorial.yml: $(MICROKIT_TUT_SRC)/../build.sh
	@tools/mk_tutorial_vars.sh $< $@

.PHONY: microkit-tutorial
microkit-tutorial: $(MICROKIT_TUT_DST_FILES) _data/microkit_tutorial.yml

RUST_TUT_REPO = _repos/sel4/sel4-rust-tutorial
RUST_TUT_BOOK = $(RUST_TUT_REPO)/book
RUST_TUT_BUILD = $(RUST_TUT_BOOK)/build
RUST_TUT_DST = _processed/rust/tutorial
RUST_TUT_FINAL_DST = projects/rust/tutorial

$(RUST_TUT_DST): $(RUST_TUT_REPO)
	SITE_URL="/projects/rust/tutorial/" \
	RUSTDOC_URL="https://sel4.github.io/seL4-rust-tutorial/rustdoc" \
		make -C $(RUST_TUT_BOOK) build
	rm -rf $(RUST_TUT_DST)
	mkdir -p $(dir $(RUST_TUT_DST))
	cp -rL $(RUST_TUT_BUILD) $(RUST_TUT_DST)
	tools/inject_backlink.sh $(RUST_TUT_DST)

.PHONY: rust-tutorial
rust-tutorial: $(RUST_TUT_DST)

.PHONY: _generate_api_pages
_generate_api_pages: _repos/sel4/sel4
	$(MAKE) markdown -C _repos/sel4/sel4/manual

PROJECT_LIBS_REPO = _repos/sel4/sel4_projects_libs
LIBSEL4VM_SRC = $(PROJECT_LIBS_REPO)/libsel4vm/docs
LIBSEL4VM_DST = projects/virtualization/docs/api
# Does not use wildcard, because _repos may not exist yet and the wildcard would then be empty.
LIBSEL4VM_FILES = \
  libsel4vm_arm_guest_vm.md \
  libsel4vm_boot.md \
  libsel4vm_guest_arm_context.md \
  libsel4vm_guest_iospace.md \
  libsel4vm_guest_irq_controller.md \
  libsel4vm_guest_memory_helpers.md \
  libsel4vm_guest_memory.md \
  libsel4vm_guest_ram.md \
  libsel4vm_guest_vcpu_fault.md \
  libsel4vm_guest_vm_util.md \
  libsel4vm_guest_vm.md \
  libsel4vm_guest_x86_context.md \
  libsel4vm_x86_guest_vm.md \
  libsel4vm_x86_ioports.md \
  libsel4vm_x86_vmcall.md
LIBSEL4VM_SRC_FILES = $(patsubst %, $(LIBSEL4VM_SRC)/%, $(LIBSEL4VM_FILES))
LIBSEL4VM_DST_FILES = $(patsubst %, $(LIBSEL4VM_DST)/%, $(LIBSEL4VM_FILES))

$(LIBSEL4VM_SRC_FILES): $(PROJECT_LIBS_REPO)

$(LIBSEL4VM_DST)/%.md: $(LIBSEL4VM_SRC)/%.md
	@echo "$<  ==>  $@"
	@tools/gen_markdown_api_doc.py -f $< -o $@ -p libsel4vm.html

$(LIBSEL4VM_DST):
	mkdir -p $@

.PHONY: generate_libsel4vm_api
generate_libsel4vm_api: $(LIBSEL4VM_DST) $(LIBSEL4VM_DST_FILES)

LIBSEL4VMM_SRC = $(PROJECT_LIBS_REPO)/libsel4vmmplatsupport/docs
# Does not use wildcard, because _repos may not exist yet and the wildcard would then be empty.
LIBSEL4VMM_FILES = \
  libsel4vmmplatsupport_arm_ac_device.md \
  libsel4vmmplatsupport_arm_generic_forward_device.md \
  libsel4vmmplatsupport_arm_guest_boot_init.md \
  libsel4vmmplatsupport_arm_guest_reboot.md \
  libsel4vmmplatsupport_arm_guest_vcpu_fault.md \
  libsel4vmmplatsupport_arm_guest_vcpu_util.md \
  libsel4vmmplatsupport_arm_vpci.md \
  libsel4vmmplatsupport_arm_vusb.md \
  libsel4vmmplatsupport_cross_vm_connection.md \
  libsel4vmmplatsupport_device_utils.md \
  libsel4vmmplatsupport_device.md \
  libsel4vmmplatsupport_guest_image.md \
  libsel4vmmplatsupport_guest_memory_util.md \
  libsel4vmmplatsupport_guest_vcpu_util.md \
  libsel4vmmplatsupport_ioports.md \
  libsel4vmmplatsupport_pci_helper.md \
  libsel4vmmplatsupport_pci.md \
  libsel4vmmplatsupport_virtio_con.md \
  libsel4vmmplatsupport_virtio_net.md \
  libsel4vmmplatsupport_x86_acpi.md \
  libsel4vmmplatsupport_x86_guest_boot_init.md \
  libsel4vmmplatsupport_x86_vmm_pci_helper.md
LIBSEL4VMM_SRC_FILES = $(patsubst %, $(LIBSEL4VMM_SRC)/%, $(LIBSEL4VMM_FILES))
# same destination dir as libsel4vm
LIBSEL4VMM_DST_FILES = $(patsubst %, $(LIBSEL4VM_DST)/%, $(LIBSEL4VMM_FILES))

$(LIBSEL4VMM_SRC_FILES): $(PROJECT_LIBS_REPO)

$(LIBSEL4VM_DST)/%.md: $(LIBSEL4VMM_SRC)/%.md
	@echo "$<  ==>  $@"
	@tools/gen_markdown_api_doc.py -f $< -o $@ -p libsel4vmm.html

.PHONY: generate_libsel4vmmplatsupport_api
generate_libsel4vmmplatsupport_api: $(LIBSEL4VM_DST) $(LIBSEL4VMM_DST_FILES)

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
generate: repos ruby_deps .npm_deps generate_api microkit microkit-tutorial rust-tutorial tutorials
ifeq ($(JEKYLL_ENV),production)
	$(MAKE) generate_data_files
endif
	mkdir -p $(JEKYLL_OUT)/$(RUST_TUT_FINAL_DST)
	rsync -a $(RUST_TUT_DST)/ $(JEKYLL_OUT)/$(RUST_TUT_FINAL_DST)/

JEKYLL_OUT = _site

.PHONY: build
build: generate
	JEKYLL_ENV=$(JEKYLL_ENV) bundle exec jekyll build $(BUILD_OPTS)

.PHONY: preview
preview: JEKYLL_ENV := production
preview: BUILD_OPTS := --config "_config.yml,_preview.yml" $(BUILD_OPTS)
preview: JEKYLL_OUT := _preview
preview: build

.PHONY: clean
clean:
	rm -rf _site
	rm -rf _preview
	rm -rf _data/generated.yml
	rm -rf _processed/microkit-tutorial
	rm -rf _processed/tutes
	rm -rf projects/virtualization/docs/api
	rm -rf $(RUST_TUT_DST) $(RUST_TUT_FINAL_DST)
	rm -f _data/microkit_tutorial.yml
	rm -f _data/microkit_platforms.yml

.PHONY: repoclean
repoclean: clean
	rm -rf _repos

.PHONY: realclean
realclean: repoclean
	rm -rf .jekyll-cache
	rm -rf vendor
	rm -rf node_modules
	rm -f .npm_deps

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

# list of URL regexps to ignore when checking links
# font preload/preconnect URLS give 404 on link check, but work;
IGNORE_URLS  = fonts.gstatic.com
IGNORE_URLS += fonts.googleapis.com
# avoid spamming GitHub too much
IGNORE_URLS += github.com.seL4.rfcs.pulls\?q
IGNORE_URLS += https://github.com/seL4/.*/edit/
# fail even though they work manually
IGNORE_URLS += https://dl.acm.org/citation.cfm\?id=917665
IGNORE_URLS += https://www.avnet.com/americas/product/avnet-engineering-services/aes-ultra96-v2-i-g/evolve-42136369/
IGNORE_URLS += https://www.microchip.com/en-us/products/fpgas-and-plds/fpga-and-soc-design-tools/soc-fpga/softconsole
IGNORE_URLS += https://wiki.odroid.com/odroid-c2/odroid-c2
IGNORE_URLS += https://wiki.odroid.com/odroid-c4/odroid-c4
IGNORE_URLS += http://ww1.microchip.com/downloads/en/DeviceDoc/9514.pdf
IGNORE_URLS += https://digilent.com/reference/programmable-logic/genesys-2/reference-manual
IGNORE_URLS += https://reference.digilentinc.com/reference/programmable-logic/genesys-2/reference-manual
IGNORE_URLS += https://www.microchip.com/en-us/development-tool/MPFS-ICICLE-KIT-ES
IGNORE_URLS += https://www.microchip.com/en-us/products/fpgas-and-plds/system-on-chip-fpgas/polarfire-soc-fpgas.*
IGNORE_URLS += https://www.amd.com/en/products/adaptive-socs-and-fpgas/evaluation-boards/ek-z7-zc706-g.html
IGNORE_URLS += https://www.amd.com/en/products/adaptive-socs-and-fpgas/evaluation-boards/ek-u1-zcu102-g.html
IGNORE_URLS += https://www.amd.com/en/products/adaptive-socs-and-fpgas/evaluation-boards/zcu106.html
# link checker complains about missing #target, but it exists and works
IGNORE_URLS += https://releases.llvm.org/8.0.0/tools/clang/docs/CrossCompilation.html
# link checker chrashes on #target reference for PPF in rust tutorial
IGNORE_URLS += https://sel4.systems/Info/Docs/seL4-manual-13.0.0.pdf

# GitHub links with dynamic internal targets such as #L12 fail in the target link check
# The #target is interpreted as comment by "make", which is what we want -- the link checker has no option
# to ignore specific targets, but we still want to know what the original target was.
IGNORE_URLS += https://github.com/seL4/seL4/blob/master/libsel4/sel4_arch_include/ia32/sel4/sel4_arch/syscalls.h#L621
IGNORE_URLS += https://github.com/seL4/seL4/blob/master/libsel4/mode_include/32/sel4/shared_types.bf#L11
IGNORE_URLS += https://github.com/seL4/seL4/blob/master/src/arch/arm/config.cmake#L21
IGNORE_URLS += https://github.com/seL4/seL4/blob/master/src/arch/x86/config.cmake#L15
IGNORE_URLS += https://github.com/seL4/seL4/blob/master/src/arch/riscv/config.cmake#L15
IGNORE_URLS += https://github.com/sel4/camkes-vm-apps/blob/master/apps/Arm/vm_minimal/tx2/devices.camkes#L40
IGNORE_URLS += https://github.com/seL4/camkes-vm-examples/blob/master/apps/x86/optiplex9020/optiplex9020.camkes#L46
IGNORE_URLS += https://github.com/u-boot/u-boot/blob/8937bb265a7f2251c1bd999784a4ef10e9c6080d/board/xilinx/zynqmp/zynqmp.c#L234
IGNORE_URLS += https://github.com/u-boot/u-boot/blob/8937bb265a7f2251c1bd999784a4ef10e9c6080d/board/xilinx/zynqmp/zynqmp.c#L234
IGNORE_URLS += https://github.com/seL4/microkit/blob/main/docs/manual.md#limits
IGNORE_URLS += https://github.com/seL4/rust-sel4/blob/main//support/targets#readme
IGNORE_URLS += https://github.com/seL4/rust-sel4/tree/main/support/targets#readme
IGNORE_URLS += https://github.com/seL4/microkit/blob/b8cf3094ba08b37198b1943ec832c3a1168f4409/libmicrokit/include/microkit.h#L14C22-L14C38
IGNORE_URLS += https://github.com/seL4/microkit/blob/b8cf3094ba08b37198b1943ec832c3a1168f4409/libmicrokit/include/microkit.h#L16C28-L16C44
IGNORE_URLS += https://github.com/seL4/seL4-rust-tutorial-code/blob/42d026476c7da08aa84ce17b99ab56dae37ff227/docker/Dockerfile#L94-L108
IGNORE_URLS += https://github.com/seL4/seL4-rust-tutorial-code/blob/42d026476c7da08aa84ce17b99ab56dae37ff227/mk/root-task.mk#L31-L36
IGNORE_URLS += https://github.com/seL4/seL4-rust-tutorial-code/blob/42d026476c7da08aa84ce17b99ab56dae37ff227/.cargo/config.toml#L8
IGNORE_URLS += https://github.com/seL4/seL4/blob/b63043c41a5db1f64253ea98b104eab54c256c56/include/benchmark/benchmark.h#L63
IGNORE_URLS += https://github.com/seL4/camkes-tool/blob/camkes-3.0.0/docs/index.md#cache-accelerator

sep:= /,/
empty:=
space:= $(empty) $(empty)
IGNORE_URLS:= $(subst /,\/,$(IGNORE_URLS))
IGNORE_EXP:= $(subst $(space),$(sep),$(IGNORE_URLS))

HTMLPROOFEROPT := --swap-urls '^https\://docs.sel4.systems:http\://localhost\:4000'
HTMLPROOFEROPT += --enforce-https=false --disable-external=false
HTMLPROOFEROPT += --ignore-urls '/$(IGNORE_EXP)/'
HTMLPROOFEROPT += --ignore-files "/.*rustdoc.*/,/rust\/tutorial\/404|print/,/projects.rust.tutorial.microkit.shared-memory.*/"
HTMLPROOFEROPT += --assume-extension ""
HTMLPROOFEROPT += --ignore-status-codes 429
# HTMLPROOFEROPT += --log-level debug
# HTMLPROOFEROPT += --disable-external=true

checklinks: build
	@bundle exec htmlproofer $(HTMLPROOFEROPT) _site

validate:
# ignore errors from inline SVG files
	@html5validator --root _site \
					--ignore 'is not a "color" value' \
							 'not allowed on element "svg"' \
							 'The "font" element is obsolete' \
							 'xmlns:svg' \
							 'sodipodi:namedview' \
							 'xmlns:inkscape' \
							 'sodipodi:role' \
							 'inkscape:label' \
							 'inkscape:groupmode' \
							 'xmlns:sodipodi' \
							 'Element "g" not allowed as child of element "clipPath"' \
							 'error: Duplicate ID "layer1".'

update:
	bundle update
	npm update
