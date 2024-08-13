#!/bin/sh
set -e

echo "Activating feature 'sccache'"

# The 'install.sh' entrypoint script is always executed as the root user.
install_debian_dependencies() {
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
  apt-get update
  apt-get install -y libssl-dev pkg-config

  apt-get clean && rm -rf /var/lib/apt/lists/*
}

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

cargo install sccache --locked --root /usr/local
