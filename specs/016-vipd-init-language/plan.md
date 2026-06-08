# Implementation Plan: VIPD Init Language Option

**Branch**: `016-vipd-init-language` | **Date**: 2026-06-08 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `specs/016-vipd-init-language/spec.md`

## Summary

Add a `--lang` option to `vipd init` that lets users choose their interaction language. The choice is persisted to the config file, respected by all subsequent vipd commands, and overridable per-command via `--lang`. Language string resources are stored in external YAML files (`lang/en.yml`, `lang/zh.yml`) with automatic English fallback for missing keys.

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS
- **TR Gates Passed**: TR0, TR1
- **Next Gate**: TR2/TR3

## Technical Context

**Language/Version**: Python 3.11+ for config/resolution tooling; YAML for string resources; SKILL.md for CLI argument handling

**Primary Dependencies**: PyYAML (for config file and language resource parsing)

**Storage**: YAML — `~/.vipd/config.yml` (user-level) and `.vipd/config.yml` (project-level) for language persistence; `lang/<code>.yml` for string resources

**Testing**: pytest for language resolution logic (priority: config > CLI flag > default); pytest for fallback behavior

**Target Platform**: Cross-platform (Linux, macOS, Windows) — all vipd commands

**Project Type**: CLI tooling — configuration extension to existing vipd-init skill

**Performance Goals**: Language resolution adds minimal overhead; language file parsing cached after first read

**Constraints**: Must be backward-compatible — existing `vipd init` usage without `--lang` must continue to work; must follow the same language code convention as `hello.sh --lang` from feature 011

**Scale/Scope**: 2 languages at launch (en, zh); external YAML files make adding languages a data-only operation

**WSJF Priority Score**: Not calculated — direct UX improvement with no competing investment

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Verification against 5 Core Principles:**

| Principle | Aligned | Evidence |
|-----------|---------|----------|
| I. Spec-First, SDD Core | ✅ | Feature was spec-first; plan implements spec intent |
| II. Dual-Track Agile | ✅ | Discovery through spec/clarify; delivery now |
| III. Agile-Stage-Gate | ✅ | Feature respects existing TR gate workflow |
| IV. Cross-Functional PDT | ✅ | Single CLI tooling feature — no cross-team coordination needed |
| V. Quality Built-In | ✅ | Fallback mechanism (missing key → English), config validation, terminal encoding detection |

**Verdict**: PASS — all 5 principles satisfied. No violations requiring Complexity Tracking.

## CBB Reuse Assessment *(IPD only)*

- **CBB Catalog**: [`.specify/memory/cbb-catalog.md`](../../.specify/memory/cbb-catalog.md)
- **Reusable blocks identified**:
  - Language code scheme from feature 011 (`hello.sh --lang en|zh|ja`)
  - Existing config file pattern (YAML/JSON persistence)
  - CLI argument parsing pattern from existing vipd skills
- **New components needed**:
  - `lang/en.yml` — English string resources
  - `lang/zh.yml` — Chinese string resources
  - Language resolver module (config → CLI flag → default priority chain)
- **Reuse justification**: Language codes reuse existing convention; no need to invent a new scheme

## Project Structure

### Documentation (this feature)

```text
specs/016-vipd-init-language/
├── spec.md                # Feature specification
├── plan.md                # This file
├── research.md            # Phase 0 output
├── data-model.md          # Phase 1 output
├── quickstart.md          # Phase 1 output
└── contracts/             # Phase 1 output
    ├── config-schema.json
    └── lang-resource-schema.json
```

### Source Code (repository root)

```text
.claude/skills/vipd-init/
└── SKILL.md               # EXTEND: add --lang parameter parsing, language-aware output

lang/                       # NEW: language string resources (at project root)
├── en.yml                  # English strings (default)
└── zh.yml                  # Chinese strings

.vipd/                      # NEW: project-level config directory (if not existing)
└── config.yml              # NEW: language key
```

## Complexity Tracking

No violations — the Constitution Check passes on all 5 principles.

---

## Phase 0: Research

Research will determine the language resource file format, config location, and priority resolution rules.

### Research Tasks

| Task | Description | Resolution |
|------|-------------|------------|
| R1 | Language resource file format | Flat YAML key-value with `section.key` naming convention |
| R2 | Config file priority resolution | CLI `--lang` > project config > user config > `en` default |
| R3 | Existing config conventions | vipd currently has no centralized config — create `.vipd/config.yml` |
| R4 | Language code validation | Whitelist-based: only supported codes accepted; others fall back to `en` with warning |

### Research output

Written to `research.md`.

---

## Phase 1: Design & Contracts

### Entities to model (→ `data-model.md`)

- `LanguageConfig` — `language` field in YAML config; resolution priority: CLI flag > project config > default
- `LanguageResource` — key-value pairs from `lang/<code>.yml`; uses `section.key` dot notation for organization
- `LanguageRegistry` — maps language codes to metadata; extensible via directory scan

### Contracts (→ `contracts/`)

- `config-schema.json` — JSON Schema for `.vipd/config.yml`
- `lang-resource-schema.json` — JSON Schema for `lang/<code>.yml` files

### Quickstart (→ `quickstart.md`)

Implementation guide covering SKILL.md extension, lang file creation, config read/write, and language resolution.

### Agent Context

Update `CLAUDE.md` SPECKIT markers to reference this plan file.
