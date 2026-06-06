# Implementation Plan: VIPD Command Prefix Renaming

**Branch**: `004-vipd-command-prefix` | **Date**: 2026-06-06 | **Spec**: `specs/004-vipd-command-prefix/spec.md`

**Input**: Feature specification from `specs/004-vipd-command-prefix/spec.md`

**Note**: This plan covers the systematic renaming of all `/vipd-speckit-*` commands
to `/vipd-speckit-*` across skill files, documentation, templates, and spec
artifacts. This is a bulk text replacement and file renaming operation.

## Summary

Rename 18 skill directories, update ~50+ file references across the entire
repository, and ensure backward compatibility by retaining old skill files
as wrappers. The rename is purely mechanical — no logic changes.

## Gate Readiness

- **Constitution Check**: ✅ PASS — v1.1.0 with Gate Criteria Reference
- **TR Gates Passed**: TR0, TR1 (spec completed)
- **Next Gate**: TR2/TR3

## Technical Context

**Language/Version**: Shell (rename/mv) + sed (bulk text replacement)

**Primary Dependencies**: None — simple filesystem operations

**Storage**: Git repository — all files in-place updates

**Testing**: `grep -r "/vipd-speckit-"` across repo should return zero matches

**Target Platform**: All — rename is platform-agnostic

**Project Type**: Bulk rename / refactoring (not software development)

**Constraints**:
- Old skill files retained as backward-compatible wrappers (FR-002)
- ALL `/vipd-speckit-*` → `/vipd-speckit-*` across ALL files (SC-001)
- Hook command names in `.specify/extensions.yml` use dotted convention

**Scale/Scope**: 18 skill dirs, ~50+ files to update across 10+ directories

## Constitution Check

**P-I (Spec-First)** ✅ — Spec defines precise rename scope. **P-II (Dual-Track)** ✅ — Delivery-only, no new discovery. **P-III (Governance)** ✅ — No gate changes. **P-IV (PDT)** ✅ — No team structure impact. **P-V (Quality)** ✅ — Automated grep verification ensures completeness.

## Project Structure

### Files to Rename or Update

| Action | Count | Path Pattern |
|--------|-------|-------------|
| Rename (copy) skill dirs | 18 | `.claude/skills/vipd-speckit-*` → `vipd-speckit-*` |
| Replace in docs | ~14 | `docs/ipd-transformation/*.md` + `zh/*.md` |
| Replace in templates | ~5 | `.specify/templates/*-template.md` + `constitution.md` |
| Replace in spec artifacts | ~45 | `specs/00*/**/*.md` |
| Rename in extensions.yml | 1 | Hook command references |

## Phase 0: Research

Research confirms:
- **17 skill directories** to copy/rename (exclude this skill itself if running via speckit)
- **grep targets**: `grep -rn "/vipd-speckit-\|speckit\."` across the repo
- **Blacklist**: `.git/` directory, `node_modules/`, binary files
- **Hook names**: `.specify/extensions.yml` uses `speckit.git.commit` format → `vipd.speckit.git.commit`

**Decision**: Use `sed -i` for bulk replacement after creating `vipd-speckit-*` copies.
Retain old `speckit-*` dirs as thin wrappers importing/redirecting to `vipd-speckit-*`.

## Phase 1: Design & Contracts

No new data model or contracts needed — this is a pure text replacement operation.
Key mapping: every occurrence of `speckit-` (in command form `/vipd-speckit-` or config
form `speckit.`) is replaced with `vipd-speckit-` / `vipd.speckit.` respectively.
