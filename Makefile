ifneq (,)
.error This Makefile requires GNU Make.
endif


# -------------------------------------------------------------------------------------------------
# Default configuration
# -------------------------------------------------------------------------------------------------
CURRENT_DIR    = $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

# shellcheck
SC_IMAGE   = koalaman/shellcheck
SC_VERSION = stable

# file lint
FL_IMAGE   = cytopia/file-lint
FL_VERSION = 0.4
FL_IGNORES = .git/,.github/


# -------------------------------------------------------------------------------------------------
# Default target
# -------------------------------------------------------------------------------------------------
help:
	@echo "lint                   Lint files"

lint: lint-files
lint: lint-shell

lint-files: _pull-fl
	@# Lint all files
	@echo "################################################################################"
	@echo "# File lint"
	@echo "################################################################################"
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(CURRENT_DIR):/data $(FL_IMAGE):$(FL_VERSION) file-cr --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(CURRENT_DIR):/data $(FL_IMAGE):$(FL_VERSION) file-crlf --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(CURRENT_DIR):/data $(FL_IMAGE):$(FL_VERSION) file-trailing-single-newline --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(CURRENT_DIR):/data $(FL_IMAGE):$(FL_VERSION) file-trailing-space --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(CURRENT_DIR):/data $(FL_IMAGE):$(FL_VERSION) file-utf8 --text --ignore '$(FL_IGNORES)' --path .
	@docker run --rm $$(tty -s && echo "-it" || echo) -v $(CURRENT_DIR):/data $(FL_IMAGE):$(FL_VERSION) file-utf8-bom --text --ignore '$(FL_IGNORES)' --path .
	@echo

lint-shell: _pull-sc
	@# Lint all Shell files
	@echo "################################################################################"
	@echo "# Shellcheck"
	@echo "################################################################################"
	@if docker run --rm $$(tty -s && echo "-it" || echo) \
		-v "${CURRENT_DIR}:/mnt" \
		-w /mnt \
		$(SC_IMAGE):$(SC_VERSION) --shell=bash aws-export-assume-profile; then \
		echo "OK"; \
	else \
		echo "Failed"; \
		exit 1; \
	fi;
	@echo

# -------------------------------------------------------------------------------------------------
# Helper Targets
# -------------------------------------------------------------------------------------------------
_pull-fl:
	docker pull $(FL_IMAGE):$(FL_VERSION)

_pull-sc:
	docker pull $(SC_IMAGE):$(SC_VERSION)
