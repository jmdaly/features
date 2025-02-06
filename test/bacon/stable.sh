#!/bin/bash

set -e

# Import test library for `check` command
source dev-container-features-test-lib

check "report bacon version" bacon --version

# Report result
reportResults
