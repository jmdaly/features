#!/bin/sh
set -e

echo "Activating feature 'bacon'"

# The 'install.sh' entrypoint script is always executed as the root user.
curl -L --proto '=https' --tlsv1.2 -sSf \
  https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash

cargo binstall bacon -y --locked
