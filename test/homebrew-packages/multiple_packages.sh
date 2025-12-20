#!/bin/bash

# This test file will be executed against a devcontainer.json that
# includes the 'homebrew-packages' Feature with multiple packages.

set -e

source dev-container-features-test-lib

# Test that all packages were installed via homebrew
check "jq is installed" jq --version
check "yq is installed" yq --version

# Report result
reportResults
