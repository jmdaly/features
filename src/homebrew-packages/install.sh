#!/usr/bin/env bash
set -e

echo "Activating feature 'homebrew-packages'"

# The 'install.sh' entrypoint script is always executed as the root user.
# Homebrew, however, should be run as a non-root user.

PACKAGES="${PACKAGES:-""}"
BREW_PREFIX="${HOMEBREW_PREFIX:-"/home/linuxbrew/.linuxbrew"}"
USERNAME="${USERNAME:-"automatic"}"

# Exit early if no packages are specified
if [ -z "$PACKAGES" ]; then
    echo "No packages specified. Skipping installation."
    exit 0
fi

# Determine the appropriate non-root user
if [ "${USERNAME}" = "auto" ] || [ "${USERNAME}" = "automatic" ]; then
    USERNAME=""
    POSSIBLE_USERS=("vscode" "node" "codespace" "$(awk -v val=1000 -F ":" '$3==val{print $1}' /etc/passwd)")
    for CURRENT_USER in "${POSSIBLE_USERS[@]}"; do
        if id -u "${CURRENT_USER}" > /dev/null 2>&1; then
            USERNAME="${CURRENT_USER}"
            break
        fi
    done
    if [ "${USERNAME}" = "" ]; then
        USERNAME=root
    fi
elif [ "${USERNAME}" = "none" ] || ! id -u "${USERNAME}" > /dev/null 2>&1; then
    USERNAME=root
fi

echo "Using user: ${USERNAME}"
echo "Installing packages: ${PACKAGES}"

# Convert comma-separated list to space-separated
PACKAGES_LIST=$(echo "${PACKAGES}" | tr ',' ' ')

# Install packages using brew as the non-root user
# Homebrew should not be run as root, so we use su to switch to the appropriate user
if [ "${USERNAME}" = "root" ]; then
    # If running as root user, just run brew directly
    # This is not recommended but may work in some scenarios
    echo "Warning: Running brew as root is not recommended."
    "${BREW_PREFIX}/bin/brew" install ${PACKAGES_LIST}
else
    # Run brew as the non-root user
    su - "${USERNAME}" -c "${BREW_PREFIX}/bin/brew install ${PACKAGES_LIST}"
fi

echo "Homebrew packages installed successfully!"
