#!/bin/sh
set -e

echo "Activating feature 'fish'"

# The 'install.sh' entrypoint script is always executed as the root user.

install_fish_ubuntu() {
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
  apt-get update && apt-get install -y software-properties-common
  apt-add-repository ppa:fish-shell/release-3 -y
  apt-get update
  apt-get install -y fish

  apt-get clean && rm -rf /var/lib/apt/lists/*
}

install_fish_debian() {
  echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
  . /etc/os-release

  echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_${VERSION_ID}/ /' \
    | tee /etc/apt/sources.list.d/shells:fish:release:3.list
  curl -fsSL https://download.opensuse.org/repositories/shells:fish:release:3/Debian_${VERSION_ID}/Release.key \
    | gpg --dearmor | tee /etc/apt/trusted.gpg.d/shells_fish_release_3.gpg > /dev/null
  apt-get update
  apt-get install -y fish

# Detemine the distro we're on by using /etc/os-release
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case $ID in
    debian)
      install_fish_debian
      ;;
    ubuntu)
      install_fish_ubuntu
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
