# Quickstart: CLI Source IPD Adaptation

## Overview

This feature renames all `speckit` references in the Python source code (`src/specify_cli/`) to the `vipd-*` convention. 29 files, ~298 occurrences.

## Rename Categories

| Category | Example Old | Example New | Count |
|----------|-------------|-------------|-------|
| Command names | `speckit-specify` | `vipd-speckit-specify` | 59 |
| Hook commands | `speckit.git.commit` | `vipd.speckit.git.commit` | 67 |
| API identifiers | `speckit_version` | `vipd_version` | 97 |
| Example refs | `speckit-foo-bar` | `vipd-foo-bar` | 11 |
| Manifest refs | `speckit.manifest.json` | `vipd.manifest.json` | 6 |

## Key Files

| File | Changes | Complexity |
|------|---------|------------|
| `extensions.py` | ~60 | HIGH — API surface rename |
| `integrations/base.py` | ~30 | HIGH — base patterns |
| `integrations/_commands.py` | ~25 | MEDIUM — templates |
| `agents.py` | ~20 | MEDIUM — registrar |
| 19 agent `__init__.py` | 1-5 each | LOW — keyword refs |

## Verification

```bash
# Count remaining speckit refs (should be 0 or intentional)
grep -rn "speckit" src/specify_cli/ | wc -l

# Test imports
cd src && python -c "import specify_cli; print('OK')"
```
