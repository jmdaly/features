#!/bin/sh
set -e

echo "Activating feature 'gdb'"

# The 'install.sh' entrypoint script is always executed as the root user.

install_gdb_debian() {
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
  apt-get update && apt-get install -y gdb

  apt-get clean && rm -rf /var/lib/apt/lists/*
}

# Detemine the distro we're on by using /etc/os-release
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case $ID in
    ubuntu|debian)
      install_gdb_debian
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
