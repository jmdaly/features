#!/bin/sh
set -e

echo "Activating feature 'rust-cli-tools'"

# The 'install.sh' entrypoint script is always executed as the root user.

INSTALL_RIPGREP=${INSTALLRIPGREP}
RIPGREP_VERSION=${RIPGREPVERSION}

INSTALL_FD=${INSTALLFD}
FD_VERSION=${FDVERSION}

INSTALL_BAT=${INSTALLBAT}
BAT_VERSION=${BATVERSION}

INSTALL_LSD=${INSTALLLSD}
LSD_VERSION=${LSDVERSION}

INSTALL_SAD=${INSTALLSAD}
SAD_VERSION=${SADVERSION}

INSTALL_DELTA=${INSTALLDELTA}
DELTA_VERSION=${DELTAVERSION}

arch=$(uname -m)

# Determine the Linux distro using /etc/os-release, and then install `curl` using the appropriate system package manager.
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case $ID in
    debian|ubuntu)
      apt-get update && apt-get install -y curl
      ;;
    centos|rhel)
      yum install -y curl
      ;;
    fedora)
      dnf install -y curl
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

if [ "$INSTALL_RIPGREP" = "true" ]; then
  echo "Installing ripgrep $RIPGREP_VERSION"

  filename_suffix=""
  # The x86_64 package has a '-musl' suffix to the filename
  if [ "$arch" = "x86_64" ]; then
    filename_suffix="-musl"
  fi

  ripgrep_filename="ripgrep-${RIPGREP_VERSION}-${arch}-unknown-linux${filename_suffix}.tar.gz"
  ripgrep_url="https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/${ripgrep_filename}"

  # Download the file with curl
  curl -fsSL $ripgrep_url -o /tmp/$ripgrep_filename

  # Extract the `rg` binary and move it to /usr/local/bin
  tar -xzf /tmp/$ripgrep_filename --strip-components=1 \
    -C /usr/local/bin \
    ripgrep-${RIPGREP_VERSION}-${arch}-unknown-linux-gnu${filename_suffix}/rg
  rm /tmp/$ripgrep_filename
fi
