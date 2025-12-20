#!/bin/bash

# This test file will be executed against a devcontainer.json that
# includes the 'homebrew-packages' Feature with a single package.

set -e

source dev-container-features-test-lib

# Test that jq was installed via homebrew
check "jq is installed" jq --version

# Report result
reportResults
