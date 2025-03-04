#!/bin/bash

set -e

# Import test library for `check` command
source dev-container-features-test-lib

check "report difftastic version" difft --version

# Report result
reportResults
