# Implementation Plan: CLI Source IPD Adaptation

**Branch**: `main` | **Date**: 2026-06-06 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/008-cli-ipd-adaptation/spec.md`

**Note**: This template is filled in by the `/vipd-speckit-plan` command. See `.specify/templates/plan-template.md` for the execution workflow.

## Summary

Rename all `speckit` references in the Python source code (`src/specify_cli/`) to the `vipd-speckit-*` convention, following the pattern already established in skill files and documentation. This is a mechanical rename across 29 files (~298 occurrences) with manual review for ambiguous cases.

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS — Principle I (Spec-First) requires source-code naming alignment with spec artifacts
- **TR Gates Passed**: TR0 (Constitution), TR1 (Spec)
- **Next Gate**: TR4 (Development)

## Technical Context

**Language/Version**: Python 3.10+ (package: `specify-cli`)

**Primary Dependencies**: typer, rich, pyyaml, httpx, packaging

**Storage**: N/A — this is a CLI tool rename

**Testing**: `pytest` (verify imports still work after rename)

**Target Platform**: Cross-platform (Windows/Linux/macOS via pip)

**Project Type**: CLI tool / Python library

**Performance Goals**: N/A — rename has no runtime impact

**Constraints**:
- Must not break the `specify` CLI entry point (it stays as-is)
- Must not break existing project `.specify/` init files
- Must maintain backward compat where extensions check `speckit_version`

**Scale/Scope**: 29 Python files, ~298 `speckit` occurrences to rename

**WSJF Priority Score**: 15 — (Value=6 + Time Criticality=4 + Risk Reduction=4) / Job Size=0.93

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

| Principle | Check | Evidence |
|-----------|-------|----------|
| I. Spec-First | PASS | Spec defined with 8 FRs, 4 SCs covering all rename categories |
| II. Dual-Track Agile | PASS | No impact on discovery/delivery tracks |
| III. Agile-Stage-Gate | PASS | Tooling naming aligns with gate enforcement system |
| IV. Cross-Functional PDT | PASS | All team members benefit from consistent naming |
| V. Quality Built-In | PASS | Systematic grep + review ensures no missed references |

## Rename Map

### Pattern 1: Command skill names (hyphen) → `vipd-speckit-*`

| Old | New | Occurrences |
|-----|-----|-------------|
| `speckit-specify` | `vipd-speckit-specify` | 5 |
| `speckit-plan` | `vipd-speckit-plan` | 11 |
| `speckit-git-commit` | `vipd-speckit-git-commit` | 7 |

### Pattern 2: Hook command names (dot) → `vipd.speckit.*`

| Old | New | Occurrences |
|-----|-----|-------------|
| `speckit.specify` | `vipd.speckit.specify` | 10 |
| `speckit.plan` | `vipd.speckit.plan` | 5 |
| `speckit.git.commit` | `vipd.speckit.git.commit` | 7 |

### Pattern 3: API identifiers → `vipd_*`

| Old | New | Occurrences |
|-----|-----|-------------|
| `speckit_version` | `vipd_version` | 90 |
| `speckit_command` | `vipd_command` | 4 |
| `speckit_manifest` | `vipd_manifest` | 3 |

### Pattern 4: Example / standalone → `vipd-*`

| Old | New | Occurrences |
|-----|-----|-------------|
| `speckit-my-extension-example` | `vipd-speckit-my-extension-example` | 3 |
| `speckit-foo-bar` | `vipd-foo-bar` | 3 |
| `speckit-xxx` | `vipd-xxx` | 2 |

### Pattern 5: Extension and manifest references

| Old | New | Occurrences |
|-----|-----|-------------|
| `speckit.manifest.json` | `vipd.manifest.json` | 2 |
| `speckit.selftest.extension` | `vipd.selftest.extension` | 2 |

## Project Structure

### Documentation (this feature)

```text
specs/008-cli-ipd-adaptation/
├── plan.md              # This file
├── research.md          # Phase 0 output
├── data-model.md        # Phase 1 output
├── quickstart.md        # Phase 1 output
├── contracts/           # Phase 1 output
└── tasks.md             # Phase 2 output
```

### Source Code (repository root)

```text
src/specify_cli/
├── __init__.py               # Package metadata
├── _assets.py                # Version function rename
├── agents.py                 # Command registrar rename
├── extensions.py             # Extension API rename
├── presets.py                # Preset references
├── shared_infra.py           # Shared references
├── commands/
│   └── init.py               # Init command references
├── integrations/
│   ├── base.py               # Base class hook patterns
│   ├── catalog.py            # Catalog references
│   ├── _commands.py          # Command template names
│   ├── _helpers.py           # Helper references
│   ├── _install_commands.py  # Install commands
│   ├── _migrate_commands.py  # Migrate commands
│   └── {19 agents}/          # Agent-specific keyword references
└── workflows/steps/
    ├── command/__init__.py
    └── prompt/__init__.py
```

**Structure Decision**: No structural changes — only content rename within existing files.

## Complexity Tracking

*No Constitution Check violations — complexity is appropriate for the scope.*
