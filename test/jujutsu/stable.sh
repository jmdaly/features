#!/bin/bash

set -e

# Import test library for `check` command
source dev-container-features-test-lib

check "report jujutsu version" jj --version

# Report result
reportResults
