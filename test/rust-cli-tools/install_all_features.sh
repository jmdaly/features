#!/bin/bash

set -e

# Import test library for `check` command
source dev-container-features-test-lib

check "report ripgrep version" rg --version
check "report fd version" fd --version
check "report bat version" bat --version
check "report lsd version" lsd --version

# Report result
reportResults
