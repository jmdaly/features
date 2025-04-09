#!/bin/sh
set -ex

echo "Activating feature 'neovim'"

NVIM_VERSION=${NVIMVERSION:-latest}

# The 'install.sh' entrypoint script is always executed as the root user.

install_debian_dependencies() {
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
  apt-get update
  apt-get install -y curl

  apt-get clean && rm -rf /var/lib/apt/lists/*
}

# Get the system's architecture with uname. If it is aarch64, set the architecture to arm64.
ARCH=$(uname -m)
if [ "$ARCH" = "aarch64" ]; then
  ARCH="arm64"
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

echo "Installing neovim $NVIM_VERSION"
FILENAME="nvim-linux-$ARCH.tar.gz"

# The URLs are slightly different for the latest and nightly versions.
if [ "$NVIM_VERSION" = "latest" ]; then
  FILENAME="$NVIM_VERSION/download/$FILENAME"
elif [ "$NVIM_VERSION" = "nightly" ]; then
  FILENAME="download/$NVIM_VERSION/$FILENAME"
fi

curl -sL https://github.com/neovim/neovim/releases/$FILENAME | tar --strip-components=1 -xvz -C /usr/local
