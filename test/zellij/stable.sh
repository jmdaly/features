#!/bin/bash

set -e

# Import test library for `check` command
source dev-container-features-test-lib

check "report zellij version" zellij --version

# Report result
reportResults
