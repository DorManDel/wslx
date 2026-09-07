#!/usr/bin/env bash
# Bash integration layer.
#
# Only shell-state features belong here. A future `wcd`, for example, must be a
# Bash function because an external child process cannot change the parent
# shell's working directory.

export WSLX_SHELL_INTEGRATION=1

# Future shell-only functions are added here, never directly into the user's
# .bashrc. The installer only injects one managed `source` block.
