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

# Install curl and unzip
if [ -f /etc/os-release ]; then
  . /etc/os-release
  case $ID in
    debian|ubuntu)
      apt-get update && apt-get install -y curl unzip
      ;;
    centos|rhel)
      yum install -y curl unzip
      ;;
    fedora)
      dnf install -y curl unzip
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

  filename_suffix="musl"
  # The aarch64 package has a '-gnu' suffix to the filename
  if [ "$arch" = "aarch64" ]; then
    filename_suffix="gnu"
  fi

  ripgrep_filename="ripgrep-${RIPGREP_VERSION}-${arch}-unknown-linux-${filename_suffix}.tar.gz"
  ripgrep_url="https://github.com/BurntSushi/ripgrep/releases/download/${RIPGREP_VERSION}/${ripgrep_filename}"

  # Download the file with curl
  curl -fsSL $ripgrep_url -o /tmp/$ripgrep_filename

  # Extract the `rg` binary and move it to /usr/local/bin
  tar -xzf /tmp/$ripgrep_filename --strip-components=1 \
    -C /usr/local/bin ripgrep-${RIPGREP_VERSION}-${arch}-unknown-linux-${filename_suffix}/rg
  rm /tmp/$ripgrep_filename
fi

if [ "$INSTALL_FD" = "true" ]; then
  echo "Installing fd $FD_VERSION"

  fd_filename="fd-v${FD_VERSION}-${arch}-unknown-linux-musl.tar.gz"
  fd_url="https://github.com/sharkdp/fd/releases/download/v${FD_VERSION}/${fd_filename}"

  # Download the file with curl
  curl -fsSL $fd_url -o /tmp/$fd_filename

  # Extract the `fd` binary and move it to /usr/local/bin
  tar -xzf /tmp/$fd_filename --strip-components=1 \
    -C /usr/local/bin fd-v${FD_VERSION}-${arch}-unknown-linux-musl/fd
  rm /tmp/$fd_filename
fi

if [ "$INSTALL_BAT" = "true" ]; then
  echo "Installing bat $BAT_VERSION"

  bat_filename="bat-v${BAT_VERSION}-${arch}-unknown-linux-gnu.tar.gz"
  bat_url="https://github.com/sharkdp/bat/releases/download/v${BAT_VERSION}/${bat_filename}"

  # Download the file with curl
  curl -fsSL $bat_url -o /tmp/$bat_filename

  # Extract the `bat` binary and move it to /usr/local/bin
  tar -xzf /tmp/$bat_filename --strip-components=1 \
    -C /usr/local/bin bat-v${BAT_VERSION}-${arch}-unknown-linux-gnu/bat
  rm /tmp/$bat_filename
fi

if [ "$INSTALL_LSD" = "true" ]; then
  echo "Installing lsd $LSD_VERSION"

  lsd_filename="lsd-v${LSD_VERSION}-${arch}-unknown-linux-gnu.tar.gz"
  lsd_url="https://github.com/lsd-rs/lsd/releases/download/v${LSD_VERSION}/${lsd_filename}"

  # Download the file with curl
  curl -fsSL $lsd_url -o /tmp/$lsd_filename

  # Extract the `lsd` binary and move it to /usr/local/bin
  tar -xzf /tmp/$lsd_filename --strip-components=1 \
    -C /usr/local/bin lsd-v${LSD_VERSION}-${arch}-unknown-linux-gnu/lsd
  rm /tmp/$lsd_filename
fi

if [ "$INSTALL_SAD" = "true" ]; then
  echo "Installing sad $SAD_VERSION"

  sad_filename="${arch}-unknown-linux-musl.zip"
  sad_url="https://github.com/ms-jpq/sad/releases/download/v${SAD_VERSION}/${sad_filename}"

  # Download the file with curl
  curl -fsSL $sad_url -o /tmp/$sad_filename

  # Unzip the `sad` binary to /usr/local/bin
  unzip -o /tmp/$sad_filename -d /usr/local/bin
  rm /tmp/$sad_filename
fi

if [ "$INSTALL_DELTA" = "true" ]; then
  echo "Installing delta $DELTA_VERSION"

  delta_filename="delta-${DELTA_VERSION}-${arch}-unknown-linux-gnu.tar.gz"
  delta_url="https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/${delta_filename}"

  # Download the file with curl
  curl -fsSL $delta_url -o /tmp/$delta_filename

  # Extract the `delta` binary and move it to /usr/local/bin
  tar -xzf /tmp/$delta_filename --strip-components=1 \
    -C /usr/local/bin delta-${DELTA_VERSION}-${arch}-unknown-linux-gnu/delta
  rm /tmp/$delta_filename
fi
