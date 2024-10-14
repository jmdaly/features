#!/bin/sh
set -e

echo "Activating feature 'host-docker-group'"

# The 'install.sh' entrypoint script is always executed as the root user.

container_user="${CONTAINERUSER}"
container_docker_group="${CONTAINERDOCKERGROUP}"

groupadd --system $container_docker_group

# We need to run the below commands while the container is running. So we write them to a script
# that will be executed as the entrypoint of the container.
tee /usr/local/share/docker-init.sh > /dev/null \
<< EOF
#!/usr/bin/env bash
set -e

# Only execute the below code if the user exists
if id -u $container_user &>/dev/null; then
	echo "Ensuring $container_user is in the $container_docker_group group"
	# Modify the newly created group to have the same GID as the host's docker group
	host_docker_group_gid=\$(stat -c %g /var/run/docker.sock)

	# Modify the group ID. The -o flag allows the group ID to be changed even if the
	# GID is already in use.
	sudo groupmod -g \$host_docker_group_gid -o $container_docker_group
	# Add the user to the new group.
	sudo usermod -aG $container_docker_group $container_user
fi

# Execute whatever commands were passed in (if any). This allows us
# to set this script to ENTRYPOINT while still executing the default CMD.
set +e
exec "\$@"
EOF

chmod +x /usr/local/share/docker-init.sh
