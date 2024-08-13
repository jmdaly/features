#!/bin/bash

set -e

# Import test library for `check` command
source dev-container-features-test-lib

check "report gdb version" gdb --version

# Report result
reportResults
