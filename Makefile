SHELL := /usr/bin/env bash
.DEFAULT_GOAL := help

.PHONY: help test lint check install uninstall reinstall doctor change clean

help:
	@printf '%s\n' \
	  'WSLX development commands' \
	  '' \
	  '  make test                 Run automated tests' \
	  '  make lint                 Run ShellCheck when installed' \
	  '  make check                Run tests + lint with final summary' \
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
		find bin lib shell scripts tests -type f -print0 | xargs -0 shellcheck -x -P SCRIPTDIR && \
		shellcheck -x -P SCRIPTDIR install.sh uninstall.sh; \
	else \
		printf 'ShellCheck not installed; lint step skipped.\n'; \
	fi

check:
	@test_rc=0; lint_rc=0; \
	$(MAKE) --no-print-directory test || test_rc=$$?; \
	$(MAKE) --no-print-directory lint || lint_rc=$$?; \
	if [[ -t 1 && -z "$${NO_COLOR:-}" && "$${TERM:-}" != "dumb" ]]; then \
		green=$$'\033[32m'; red=$$'\033[31m'; cyan=$$'\033[36m'; bold=$$'\033[1m'; reset=$$'\033[0m'; \
	else \
		green=''; red=''; cyan=''; bold=''; reset=''; \
	fi; \
	printf '\n%s%sWSLX CHECK SUMMARY%s\n' "$$bold" "$$cyan" "$$reset"; \
	printf '%s\n' '----------------------------------------'; \
	if (( test_rc == 0 )); then \
		printf '%s[PASS]%s tests       exit=0\n' "$$green" "$$reset"; \
	else \
		printf '%s[FAIL]%s tests       exit=%d\n' "$$red" "$$reset" "$$test_rc"; \
		printf '       rerun: make test\n'; \
	fi; \
	if (( lint_rc == 0 )); then \
		printf '%s[PASS]%s ShellCheck  exit=0\n' "$$green" "$$reset"; \
	else \
		printf '%s[FAIL]%s ShellCheck  exit=%d\n' "$$red" "$$reset" "$$lint_rc"; \
		printf '       rerun: make lint\n'; \
	fi; \
	if (( test_rc == 0 && lint_rc == 0 )); then \
		printf '\n%s%sResult: PASS%s\n' "$$green" "$$bold" "$$reset"; \
		exit 0; \
	fi; \
	printf '\n%s%sResult: FAIL%s (exit=1)\n' "$$red" "$$bold" "$$reset"; \
	exit 1

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
