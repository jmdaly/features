#!/bin/bash

set -e

# Import test library for `check` command
source dev-container-features-test-lib

check "report sccache version" sccache --version

# Report result
reportResults
