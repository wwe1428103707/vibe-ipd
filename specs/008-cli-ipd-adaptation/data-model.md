# Data Model: CLI Source IPD Adaptation

## RenameEntity

| Field | Type | Description |
|-------|------|-------------|
| old_pattern | string | The original `speckit*` string to replace |
| new_pattern | string | The replacement `vipd*` string |
| context | enum | `command` / `hook` / `api` / `example` / `manifest` |
| occurrences | int | Count of occurrences in source |
| files_affected | string[] | List of file paths |

## Rename Rules

| Rule | Old Pattern | New Pattern | Context | Occurrences |
|------|------------|-------------|---------|-------------|
| R1 | `speckit-specify` | `vipd-speckit-specify` | command | 5 |
| R2 | `speckit-plan` | `vipd-speckit-plan` | command | 11 |
| R3 | `speckit-git-commit` | `vipd-speckit-git-commit` | command | 7 |
| R4 | `speckit.specify` | `vipd.speckit.specify` | hook | 10 |
| R5 | `speckit.plan` | `vipd.speckit.plan` | hook | 5 |
| R6 | `speckit.git.commit` | `vipd.speckit.git.commit` | hook | 7 |
| R7 | `speckit_version` | `vipd_version` | api | 90 |
| R8 | `speckit_command` | `vipd_command` | api | 4 |
| R9 | `speckit_manifest` | `vipd_manifest` | api | 3 |
| R10 | `speckit-xxx` | `vipd-xxx` | example | 2 |
| R11 | `speckit-foo-bar` | `vipd-foo-bar` | example | 3 |
| R12 | `speckit-my-extension-example` | `vipd-speckit-my-extension-example` | example | 3 |
| R13 | `speckit.manifest.json` | `vipd.manifest.json` | manifest | 2 |
| R14 | `speckit.selftest.extension` | `vipd.selftest.extension` | manifest | 2 |

## Category Classification

```yaml
rename_categories:
  command_names:
    pattern: "speckit-{name} → vipd-speckit-{name}"
    files: [base.py, _commands.py, _install_commands.py, _migrate_commands.py]
    examples: [speckit-specify, speckit-plan, speckit-git-commit]

  hook_names:
    pattern: "speckit.{name} → vipd.speckit.{name}"
    files: [base.py, agents.py]
    examples: [speckit.specify, speckit.git.commit]

  api_identifiers:
    pattern: "speckit_{name} → vipd_{name}"
    files: [extensions.py, init.py, _assets.py]
    examples: [speckit_version, speckit_command, speckit_manifest]

  integration_keywords:
    pattern: "agent-specific speckit refs → vipd-*"
    files: [19 agent __init__.py files]
    examples: [grep results per integration]
```

## File Classification

```yaml
high_impact_files:
  - src/specify_cli/extensions.py  # ~60 changes — API surface
  - src/specify_cli/integrations/base.py  # ~30 changes — base patterns
  - src/specify_cli/integrations/_commands.py  # ~25 changes — templates
  - src/specify_cli/agents.py  # ~20 changes — registrar

medium_impact_files:
  - src/specify_cli/commands/init.py  # 6 changes
  - src/specify_cli/integrations/_install_commands.py  # template names
  - src/specify_cli/integrations/_migrate_commands.py  # template names

low_impact_files:
  - src/specify_cli/presets.py  # preset references
  - src/specify_cli/shared_infra.py  # shared infrastructure
  - src/specify_cli/workflows/steps/command/__init__.py  # step names
  - src/specify_cli/workflows/steps/prompt/__init__.py  # step names
  - 19 integration __init__.py files each with 1-5 keyword changes
```
