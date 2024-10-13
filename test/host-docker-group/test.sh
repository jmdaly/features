#!/bin/bash

# This test file will be executed against an auto-generated devcontainer.json that
# includes the 'host-docker-group' Feature with no options.
#
# For more information, see: https://github.com/devcontainers/cli/blob/main/docs/features/test.md
#
# Eg:
# {
#    "image": "<..some-base-image...>",
#    "features": {
#      "host-docker-group": {}
#    },
#    "remoteUser": "root"
# }
#
# Thus, the value of all options will fall back to the default value in the
# Feature's 'devcontainer-feature.json'.
# For the 'rust-cli-tools' feature, that means the default feature is 'stable'.
#
# These scripts are run as 'root' by default. Although that can be changed
# with the '--remote-user' flag.
# 
# This test can be run with the following command:
#
#    devcontainer features test    \ 
#               --features host-docker-group   \
#               --remote-user root \
#               --skip-scenarios   \
#               --base-image mcr.microsoft.com/devcontainers/base:ubuntu \
#               /path/to/this/repo

set -e

username="${CONTAINERUSER}"

# Optional: Import test library bundled with the devcontainer CLI
source dev-container-features-test-lib

# The docker CLI is required by the 'host-docker-group' feature, and is not
# installed by default. We will install it here.
arch=$(uname -m)
case "$arch" in
	'x86_64')
		url='https://download.docker.com/linux/static/stable/x86_64/docker-27.3.1.tgz';
		;;
	'armhf')
		url='https://download.docker.com/linux/static/stable/armel/docker-27.3.1.tgz';
		;;
	'armv7')
		url='https://download.docker.com/linux/static/stable/armhf/docker-27.3.1.tgz';
		;;
	'aarch64')
		url='https://download.docker.com/linux/static/stable/aarch64/docker-27.3.1.tgz';
		;;
	*) echo >&2 "error: unsupported 'docker.tgz' architecture ($arch)"; exit 1 ;;
esac;

sudo wget -O 'docker.tgz' "$url"

sudo tar --extract \
	--file docker.tgz \
	--strip-components 1 \
	--directory /usr/local/bin/ \
	--no-same-owner \
	'docker/docker'

sudo rm docker.tgz
docker --version

# Feature-specific tests
# The 'check' command comes from the dev-container-features-test-lib.

# Use the `su` command to run `docker ps` as user $username
# This will fail if the user is not in the docker group
check "user $(whoami) can run 'docker ps'" docker ps

# Report result
# If any of the checks above exited with a non-zero exit code, the test will fail.
reportResults
