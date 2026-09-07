SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

.PHONY: help test lint check install uninstall reinstall doctor change clean

help:
	@printf '%s\n' \
	  'WSLX development commands' \
	  '' \
	  '  make test                 Run automated tests' \
	  '  make lint                 Run ShellCheck when installed' \
	  '  make check                Run tests + lint' \
	  '  make install              Install WSLX for the current user' \
	  '  make uninstall            Uninstall WSLX for the current user' \
	  '  make reinstall            Uninstall then install' \
	  '  make doctor               Run the repository doctor' \
	  '  make change NAME=<name>   Create a timestamped change record' \
	  '  make clean                Remove local temporary output'

test:
	@bash tests/run.sh

lint:
	@if command -v shellcheck >/dev/null 2>&1; then \
		printf 'Running ShellCheck...\n'; \
		find bin lib shell scripts tests -type f -print0 | xargs -0 shellcheck; \
		shellcheck install.sh uninstall.sh; \
	else \
		printf 'ShellCheck not installed; lint step skipped.\n'; \
	fi

check: test lint

install:
	@./install.sh

uninstall:
	@./uninstall.sh

reinstall:
	@./uninstall.sh --yes || true
	@./install.sh

doctor:
	@./bin/wslx doctor

change:
	@if [[ -z "$(NAME)" ]]; then \
		printf 'Usage: make change NAME=<short-change-name>\n' >&2; \
		exit 2; \
	fi
	@./scripts/new-change.sh "$(NAME)"

clean:
	@rm -rf .tmp dist coverage
