
# Host Docker Group (host-docker-group)

Ensures the container user has the correct permissions to use the docker socket. This is accomplished by adding the container user to a group with the same GID as the host docker group. This feature also mounts the docker socket into the container.

## Example Usage

```json
"features": {
    "ghcr.io/jmdaly/features/host-docker-group:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| containerUser | The user to add to the docker group. This user must exist in the container. | string | vscode |
| containerDockerGroup | The name to give the docker group in the container. | string | host-docker |

This features assumes that the Docker daemon is installed on the host
computer, and that the Docker CLI tools are already installed in the
container.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/jmdaly/features/blob/main/src/host-docker-group/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
