#!/bin/bash

set -e

# Import test library for `check` command
source dev-container-features-test-lib

check "report neovim version" nvim --version

# Report result
reportResults
