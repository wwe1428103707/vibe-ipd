# Research: IPD Migration Functional Gaps

**Feature**: 009-ipd-migration-gaps | **Date**: 2026-06-07

## Decision 1: Gate Enforcement Architecture

**Decision**: Hard gate model with subprocess invocation

**Rationale**: The clarification session resolved that gate checks must block command execution entirely when failed (Constitution Principle III: "No feature MAY transition to the next stage without passing its current stage gate"). The SpecKit codebase consistently uses `subprocess.run()` for external tool invocation — ShellStep, version upgrades, and integration commands all follow this pattern. Reimplementing gate logic in Python would violate DRY and create maintenance burden.

**Alternatives considered**:
- Soft gate with audit log (rejected: violates Constitution Principle III's explicit mandate)
- Suggestion-only mode (rejected: provides no enforcement, makes IPD governance optional)
- Python native rewrite of gate logic (rejected: violates DRY, duplicates 400+ lines of PS1/Bash logic)

## Decision 2: Per-Feature Gate Status Storage

**Decision**: Each feature gets its own `specs/NNN-feature-name/gate-status.json`

**Rationale**: The current project-level `.specify/memory/gate-status.json` has a flat structure with only 6 gate slots shared across all features. In a multi-feature project, this means features overwrite each other's gate status. The `specs/NNN-feature-name/` directory is already the canonical location for per-feature artifacts (spec.md, plan.md, tasks.md), so gate-status.json follows the same convention.

**Alternatives considered**:
- Single file with feature namespaced keys (rejected: makes JSON unreadable, requires schema migration, doesn't scale)
- New `.specify/gates/` directory (rejected: introduces a new parallel structure when specs/ already exists)

## Decision 3: Gate Depth Validation Method

**Decision**: Regex-based content pattern matching with minimum 3 patterns per gate

**Rationale**: The constitution defines specific Must-Meet criteria (e.g., TR1: "Spec created with user stories, feasibility assessed"). While AI-based semantic analysis would be more accurate, it adds latency, cost, and non-determinism. Regex patterns are deterministic, fast (<10ms), and can validate that substantive content exists. The minimum 3 patterns per gate ensure reasonable coverage without false positives.

**Specific patterns per gate**:
- TR1: (1) user story headings `### User Story`, (2) Given/When/Then acceptance scenarios, (3) "TR Gate Assessment" section
- TR2_TR3: (1) "Gate Readiness" section, (2) Architecture decisions, (3) Data model or API contracts
- TR4: (1) Task items with IDs `- [ ] T\d+`, (2) "Gate Completion Verification", (3) Phase structure
- TR4A: (1) Completed task checkboxes `- [x] T\d+`, (2) Completion ratio > threshold, (3) Quality summary
- TR5: (1) All prior gates passed in gate-status.json, (2) Cross-artifact references, (3) Test/verification evidence
- TR6: (1) Deployment verification section, (2) Ops handover documentation, (3) Training completion evidence

**Alternatives considered**:
- AI-based semantic analysis (rejected: non-deterministic, slow, costly, requires LLM at gate-check time)
- Full document parsing with AST (rejected: overkill for gate validation, fragile)

## Decision 4: Gate Status Schema Evolution

**Decision**: Extend gate-status.json to support per-feature paths, audit trail, Go/Kill/Hold/Recycle decisions, and TR6

**Rationale**: The current schema supports only `passed/pending/failed/skipped` status values, no audit trail, and no TR6. The constitution mandates Go/Kill/Hold/Recycle decisions and audit evidence. The new schema adds:
- `TR6` gate entry
- `decision` field per gate (Go/Kill/Hold/Recycle) alongside `status`
- `history` array per gate for audit trail
- `decision_maker` and `decision_rationale` fields

**Full new schema**:
```json
{
  "ipd_mode": true,
  "feature": "009-ipd-migration-gaps",
  "last_updated": "2026-06-07",
  "gates": {
    "TR0": {
      "status": "passed",
      "decision": "Go",
      "evidence": "...",
      "decision_maker": "",
      "decision_rationale": "",
      "date": "2026-06-06",
      "history": [
        {"from": "pending", "to": "passed", "date": "2026-06-06", "evidence": "..."}
      ]
    }
  }
}
```

## Decision 5: Product Trio Review Integration Pattern

**Decision**: Enforce as a gate evidence requirement (not a blocking workflow step)

**Rationale**: Solo developers and small teams may not have three distinct people. Enforcing Trio as a blocking step would make VIPD unusable for individuals. Instead, TR1 gate evidence must include a Trio verdict section with per-perspective scores, but the verdict can be self-assessed by a single person wearing multiple hats.

**Alternatives considered**:
- Mandatory multi-person Trio review (rejected: unusable for solo developers)
- Optional Trio section (rejected: provides no enforcement, contradicts Principle II)

## Decision 6: CBB Catalog Implementation

**Decision**: Template file at `.specify/memory/cbb-catalog.md` with manual population

**Rationale**: Automated CBB discovery would require code analysis (AST parsing, dependency graphing) that is out of scope for this feature. A structured Markdown template gives teams a clear starting point and can be evolved to auto-population in a future feature.

**Alternatives considered**:
- Automated CBB discovery from codebase (rejected: out of scope, would be a separate feature)
- No CBB catalog (rejected: violates Principle IV mandate for CBB reuse)

## Decision 7: Workflow Migration Strategy

**Decision**: Create `.specify/workflows/vipd/workflow.yml` as a new file alongside the existing `speckit/` workflow. Add backward-compatible aliases. Deprecate `speckit/` after one major version.

**Rationale**: The existing `speckit/workflow.yml` is referenced by `workflow-registry.json` and may be in active use. Creating a parallel `vipd/` workflow avoids breaking existing CI/CD pipelines while introducing the IPD-aware version. The `init` command already supports installing to a `vipd/` key.

**Alternatives considered**:
- In-place rename of speckit/ to vipd/ (rejected: breaks existing installations and CI/CD)
- No new workflow, only update commands (rejected: doesn't address FR-005 GatewayStep IPD-awareness)