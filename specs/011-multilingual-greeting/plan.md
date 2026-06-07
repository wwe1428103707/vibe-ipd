# Implementation Plan: Multilingual Greeting

**Branch**: `011-multilingual-greeting` | **Date**: 2026-06-07 | **Spec**: [spec.md](spec.md)

**Input**: Feature specification from `/specs/011-multilingual-greeting/spec.md`

## Summary

Extend the `hello.sh` CLI greeting tool with a `--lang` option supporting English (`en`), Chinese (`zh`), and Japanese (`ja`) greetings. The feature adds localized welcome messages while maintaining backward compatibility — omitting `--lang` defaults to English.

## Technical Context

**Language/Version**: Bash (POSIX-compatible). Verified on Git Bash for Windows.

**Primary Dependencies**: None. Pure shell script — no external translation services or libraries needed.

**Storage**: N/A — stateless CLI tool. Greeting strings embedded in the script.

**Testing**: Manual assertion testing by running `hello.sh --name <NAME> --lang <CODE>` and checking stdout/stderr output.

**Target Platform**: Git Bash / WSL on Windows 11. Requires UTF-8 capable terminal.

**Project Type**: CLI tool (single bash script extending existing hello.sh)

**Constraints**: Must be backward compatible — existing `--name`, `--help`, `--version` flags must continue working.

**Scale/Scope**: 3 languages, single script file change.

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS (same constitution applies)
- **TR Gates Passed**: TR0 (Constitution), TR1 (Spec — newly created)
- **Next Gate**: TR2/TR3 (Plan & Design)

## Research

[See research.md](research.md) — Language greeting localization decisions.

## Project Structure

### Documentation (this feature)

```text
specs/011-multilingual-greeting/
├── plan.md              # This file
├── research.md          # Phase 0 — localization decisions
├── data-model.md        # Phase 1 — greeting message entities
├── quickstart.md        # Phase 1 — test scenarios
├── contracts/           # Phase 1 — CLI interface updates
│   └── cli-contract.md
└── spec.md              # Feature specification
```

### Source Code (repository root)

```text
samples/e2e-validate-hello/
├── README.md
└── hello.sh             # Modified — --lang option added
```
