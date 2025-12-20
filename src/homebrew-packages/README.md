# Homebrew Packages (homebrew-packages)

Install Homebrew packages by specifying a comma-separated list of package names.

## Example Usage

```json
"features": {
    "ghcr.io/jj/features/homebrew-packages:1": {
        "packages": "jq,yq,gh"
    }
}
```

## Options

| Option | Description | Type | Default |
|--------|-------------|------|---------|
| packages | Comma-separated list of Homebrew packages to install. | string | - |

## Dependencies

This feature depends on the Homebrew feature:
- `ghcr.io/meaningful-ooo/devcontainer-features/homebrew:2`

The Homebrew feature will be automatically installed before this feature runs.

## Notes

- Homebrew runs as a non-root user. This feature automatically detects the appropriate user (vscode, node, codespace, or the user with UID 1000) to run `brew install`.
- If no packages are specified, the feature will skip installation.
- Multiple packages can be installed by separating them with commas (e.g., `"jq,yq,gh"`).

---

_Note: This file was auto-generated from the [devcontainer-feature.json](devcontainer-feature.json). Add additional notes to a `NOTES.md`._
