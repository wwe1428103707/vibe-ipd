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

**Performance Goals**: N/A — stateless CLI with no throughput requirement; all greetings render in <100ms.

**WSJF Priority Score**: 8 — (Value: 6 + Time Criticality: 1 + Risk Reduction: 1) / Job Size: 1 *(IPD only)*

**Scale/Scope**: 3 languages, single script file change.

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

**Principle I — Spec-First, Intent-Driven Development**: ✅ PASS
- Spec (spec.md) defines what & why; technology choices deferred to plan phase.
- User stories with independently testable acceptance criteria present.

**Principle II — Dual-Track Agile**: ✅ PASS
- Feature scope is well-defined and validated from the prior concept phase.
- No discovery-track concerns — feature is a straightforward extension.

**Principle III — Agile-Stage-Gate Governance**: ✅ PASS
- TR1 (Concept) gate passed with spec completeness.
- Planning within TR2/TR3 boundary.
- No gate-skipping: TR gates documented in spec.md TR Gate Assessment.

**Principle IV — Cross-Functional PDT**: ✅ N/A
- Single-script feature with no cross-team dependency; PDT assignment needed at implementation phase only.

**Principle V — Quality Built-In with Automated Gate Verification**: ✅ PASS
- Manual test scenarios defined in quickstart.md for all 3 languages + error cases.
- Shift-left: testing by running assertions before marking complete.

**Overall**: ✅ PASS (4 pass, 1 N/A — no violations)

## Gate Readiness *(IPD only)*

- **Constitution Check**: PASS (all 5 principles verified)
- **TR Gates Passed**: TR0 (Constitution), TR1 (Spec — newly created)
- **Next Gate**: TR2/TR3 (Plan & Design) — *current*

## CBB Reuse Assessment *(IPD only)*

- **CBB Catalog**: Not yet established (single-project context).
- **Reusable blocks identified**: None — this is a feature extension on a sample project.
- **New components needed**: Modification to `samples/e2e-validate-hello/hello.sh` only.
- **Reuse justification**: No existing CBBs match this scope; purpose-built CLI argument parsing and greeting templates are within the single script.

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

## Complexity Tracking

> **No Constitution Check violations** — this section intentionally left blank per template guidance.
>
> The feature is contained to a single script with no architectural complexity concerns.
