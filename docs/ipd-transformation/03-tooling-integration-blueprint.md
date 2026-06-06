**Document**: Tooling Integration Blueprint
**Part of**: IPD Toolkit Transformation Plan Collection
**Status**: Draft
**Date**: 2026-06-06

# Tooling Integration Blueprint

## Overview

The Agile-Stage-Gate hybrid model requires IPD Technology Review (TR) gate
enforcement integrated into the development workflow. This blueprint describes
Spec Kit's native **document-state mode** — gate enforcement through AI agent
commands and project document structure, requiring no external tooling or
platform configuration.

The Spec Kit toolchain embeds TR gate awareness directly into each
`/speckit-*` command. When IPD mode is active (detected by the presence of a
"Gate Criteria Reference" section in the project constitution), commands
automatically perform pre-flight gate checks using deep content validation
against the project's own documents (constitution, spec, plan, tasks).

## Spec Kit Agent Integration (Document-State Mode)

Spec Kit provides native gate enforcement through its AI agent command system.
This "document-state mode" works without external tooling by having each
`/speckit-*` command perform pre-flight TR gate checks against the project's
own documentation.

### How It Works

1. **IPD Mode Detection**: Each command first checks if the project's
   constitution contains a "Gate Criteria Reference" section. If yes, IPD
   mode is active; if no, the project is SDD-only and gate checks are skipped.

2. **Deep Content Validation**: Instead of simple file-existence checks, each
   command performs deep content validation — verifying that required sections
   exist within the relevant documents (constitution, spec, plan, tasks).

3. **Gate Flow Enforcement**: Commands enforce sequential gate progression:
   - `/speckit-constitution` → TR0 (project setup)
   - `/speckit-specify`, `/speckit-clarify` → TR1 (concept)
   - `/speckit-checklist`, `/speckit-plan` → TR2/TR3 (plan/design)
   - `/speckit-tasks` → TR4 (development baseline)
   - `/speckit-implement` → TR4/TR4A (development)
   - `/speckit-analyze` → TR5 (validation)

### Comparison: Document-State vs External Tooling

| Aspect | Document-State Mode | External Tooling Integration |
|--------|-------------------|-----------------------------|
| External tools required | None | Depends on platform choice |
| Gate enforcement | Pre-flight command checks | Platform automation rules |
| Evidence collection | Document content analysis | Platform issue fields |
| Dependency tracking | Cross-reference links | Platform dependency views |
| Setup effort | None (built into Spec Kit) | Requires platform configuration |

## Platform Alternatives

For teams that need to integrate with external project management platforms,
the gate process remains the same; only the automation mechanism changes.
The common patterns (TR gate definitions, Must-Meet/Should-Meet criteria,
deep content validation) apply regardless of platform. Refer to the
[Glossary](glossary.md) for canonical IPD/Agile term definitions.

## Cross-References

- [Command & Template Redesign Guide](02-command-template-redesign-guide.md)
  — gate definitions and TR mapping
- [Transformation Roadmap](01-transformation-roadmap.md) — Phase 2 timing
  for tooling configuration

*This blueprint aligns with **Principle V (Quality Built-In with Automated
Gate Verification)** by defining document-state gate enforcement, and
**Principle III (Agile-Stage-Gate Governance)** by translating TR gate
criteria into command pre-flight checks.*
