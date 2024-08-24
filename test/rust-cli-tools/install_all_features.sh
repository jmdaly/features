#!/bin/bash

set -e

# Import test library for `check` command
source dev-container-features-test-lib

check "report ripgrep version" rg --version

# Report result
reportResults
