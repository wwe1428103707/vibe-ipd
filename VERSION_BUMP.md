# Version Bump Process

VIPD follows **semantic versioning** (MAJOR.MINOR.PATCH), using the same conventions as speckit but tracked independently.

## When to Bump

| Bump | When | Example |
|------|------|---------|
| **MAJOR** | Breaking workflow changes, backward-incompatible format changes | `1.0.0` → `2.0.0` |
| **MINOR** | New features implemented (new specs completed) | `1.0.0` → `1.1.0` |
| **PATCH** | Bug fixes, documentation updates, refactoring | `1.0.0` → `1.0.1` |

## Bump Process

### Using the bump script (recommended)

```bash
# Bump patch version (bug fixes, docs)
.vipd/bump_version.sh patch

# Bump minor version (new features)
.vipd/bump_version.sh minor

# Bump major version (breaking changes)
.vipd/bump_version.sh major
```

### Manual process

If you prefer to update manually:

1. Edit `.vipd/version.yml` — update the `vipd_version` field
2. Add an entry to `CHANGELOG.md` following Keep a Changelog format
3. Commit with message: `chore: bump version to X.Y.Z`
4. Tag the release: `git tag vX.Y.Z`
5. Push tags: `git push origin main --tags`

## Important Notes

- **Only `vipd_version` is bumped** during releases. The `speckit_version` field changes only when the project updates its speckit dependency.
- Version bumps should be **committed separately** from feature work (one commit for the bump, one for the feature).
- Pre-release suffixes are supported (e.g., `1.0.0-beta`, `2.0.0-rc.1`).
