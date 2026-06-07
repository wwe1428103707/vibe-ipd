# Research: CLI Source IPD Adaptation

## Rename Analysis

### Total Scope
- **29 files** contain `speckit` references
- **298 total occurrences** across 5 rename categories

### Category Breakdown

| Category | Pattern | Count | Example |
|----------|---------|-------|---------|
| Hyphenated skill names | `speckit-{name}` → `vipd-speckit-{name}` | 59 | `speckit-specify` → `vipd-speckit-specify` |
| Dot-notation hook commands | `speckit.{name}` → `vipd.speckit.{name}` | 67 | `speckit.git.commit` → `vipd.speckit.git.commit` |
| API identifiers | `speckit_{name}` → `vipd_{name}` | 97 | `speckit_version` → `vipd_version` |
| Example/standalone | `speckit-{example}` → `vipd-{example}` | 11 | `speckit-foo-bar` → `vipd-foo-bar` |
| Extension/manifest | `speckit.*` → `vipd.*` | 6 | `speckit.manifest.json` → `vipd.manifest.json` |
| Standalone `speckit` | various | 21 | Context-dependent |

### Affected Modules

| Module | Files | Total Occurrences | Nature of Changes |
|--------|-------|-------------------|-------------------|
| `init.py` | 1 | 6 | Version string + command refs |
| `extensions.py` | 1 | ~60 | API names + command refs |
| `base.py` | 1 | ~30 | Hook patterns + command templates |
| `_commands.py` | 1 | ~25 | Command template names |
| `agents.py` | 1 | ~20 | Command registrar config |
| `agenty integrations` | 19 | ~100 | Keyword references per agent |
| `workflows/steps` | 2 | ~10 | Command step references |
| `others` | 3 | ~15 | Presets, shared infra, assets |

### Integration-Specific Keywords

Each integration (`claude`, `copilot`, `cursor_agent`, etc.) references `speckit` in its `__init__.py`. These are typically:
- Command name strings in `_COMMANDS` or keyword lists
- Argument hint dictionaries
- Install/migrate command templates

### Key Finding: `speckit_version` API Impact

`speckit_version` appears 90 times and is a public API for extension compatibility checking (in `extensions.py`). Renaming to `vipd_version` changes the extension manifest contract. All extensions that check `requires.speckit_version` will need to check `requires.vipd_version` instead. This is acceptable since this is an IPD fork.

### Edge Cases Identified

1. **Backward compat**: `specify init` generates `.specify/` configs. The generated content should reference `vipd-*` names going forward.
2. **Extension compatibility**: Extensions checking `speckit_version` will break. This is acceptable for the IPD fork.
3. **Version API**: `get_speckit_version()` → `get_vipd_version()` — ensures the CLI reports the forked version.

## Decisions

1. **Dot-notation hooks**: `speckit.{command}` → `vipd.speckit.{command}` — preserves the `speckit` sub-namespace for hook organization
2. **Hyphenated commands**: `speckit-{command}` → `vipd-speckit-{command}` — matches existing skill file naming
3. **API identifiers**: `speckit_*` → `vipd_*` — clean break from upstream
4. **`specify` CLI name**: UNCHANGED — the tool entry point stays
5. **`specify_cli` package**: UNCHANGED — the Python package name stays
