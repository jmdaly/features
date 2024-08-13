#!/bin/sh
set -e

echo "Activating feature 'neovim'"

VERISON=${VERSION:-stable}

# The 'install.sh' entrypoint script is always executed as the root user.

install_debian_dependencies() {
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
  apt-get update
  apt-get install -y ninja-build gettext cmake unzip curl build-essential

  apt-get clean && rm -rf /var/lib/apt/lists/*
}

ADJUSTED_VERSION=$VERSION

if [  "$VERSION" != "stable" ] && [  "$VERSION" != "nightly" ]; then
    ADJUSTED_VERSION="v$VERSION"
fi

# Detemine the distro we're on by using /etc/os-release
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case $ID in
    debian)
      install_debian_dependencies
      ;;
    ubuntu)
      install_debian_dependencies
      ;;
    *)
      echo "Unsupported distro: $ID"
      exit 1
      ;;
  esac
else
  echo "Unsupported distro"
  exit 1
fi

echo "Downloading neovim $ADJUSTED_VERSION"

curl -sL https://github.com/neovim/neovim/archive/refs/tags/${ADJUSTED_VERSION}.tar.gz | tar -xzC /tmp 2>&1

echo "Building neovim $ADJUSTED_VERSION"
cd /tmp/neovim-${ADJUSTED_VERSION}
make CMAKE_BUILD_TYPE=Release
make install

echo "Cleaning up"
rm -rf /tmp/neovim-${ADJUSTED_VERSION}
