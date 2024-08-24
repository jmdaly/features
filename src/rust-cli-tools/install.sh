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

if [ "$INSTALL_RIPGREP" = "true" ]; then
  echo "Installing ripgrep $RIPGREP_VERSION"
  cargo install ripgrep --version $RIPGREP_VERSION

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
