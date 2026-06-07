# Contracts: Rename Specification

## Rename Contract

Every rename must follow these rules to ensure consistency:

### Rule 1: Command Skill Names

```
Pattern: speckit-{name} → vipd-speckit-{name}
Scope:   Command references in source, templates, and generated output
Example: speckit-specify → vipd-speckit-specify
Note:    Preserves the `speckit` sub-name to indicate upstream origin
```

### Rule 2: Hook Dot-Notation

```
Pattern: speckit.{name} → vipd.speckit.{name}
Scope:   Hook command names in extension configs and agent registrars
Example: speckit.git.commit → vipd.speckit.git.commit
Note:    The dot-to-hyphen mapping rule still applies at invocation time:
         vipd.speckit.git.commit → /vipd-speckit-git-commit
```

### Rule 3: API Identifiers

```
Pattern: speckit_{name} → vipd_{name}
Scope:   Python identifiers (variables, functions, class members)
Example: speckit_version → vipd_version
         get_speckit_version() → get_vipd_version()
Note:    This is a breaking change for extension API consumers
```

### Rule 4: Standalone / Example References

```
Pattern: speckit-{text} → vipd-{text}
Scope:   Example names, test fixtures, documentation strings in source
Example: speckit-foo-bar → vipd-foo-bar
         speckit-my-extension-example → vipd-speckit-my-extension-example
```

### Rule 5: Manifest References

```
Pattern: speckit.{file} → vipd.{file}
Scope:   File names referenced in extension manifests
Example: speckit.manifest.json → vipd.manifest.json
Note:    Only rename the prefix, not the file extension
```

## Extension Compatibility Contract

After rename, extensions that previously checked `requires.speckit_version` will need to check `requires.vipd_version`. The `ExtensionManifest` class is updated accordingly.

```python
# Before
manifest.requires_speckit_version → "1.0.0"

# After
manifest.requires_vipd_version → "1.0.0"
```

## Verification Contract

After all renames are applied:

```bash
# Should return 0 unexpected matches
grep -rn "speckit" src/specify_cli/ | grep -v "speckit_version" | grep -v "__init__"

# Python import test
python -c "import specify_cli; print('OK')"

# If pyproject.toml exists
pip install -e . && specify --help
```
