# Contract: Gate Check Depth Validation

**Feature**: 009-ipd-migration-gaps | **Date**: 2026-06-07

## Purpose

Defines the contract for substantive content validation at each TR gate, replacing the current section-header-only checks with regex-based content pattern matching.

## Must-Meet Validation Patterns

### TR1 — Concept Gate

Must-Meet criteria: "Spec created with user stories, feasibility assessed"

| Pattern ID | Regex Pattern | Meaning | Failure Message |
|-----------|---------------|---------|-----------------|
| TR1-MM-1 | `^###\s+User Story` or `^###\s+User Story.*Priority` | User story headings exist | "Spec must contain at least one user story with priority" |
| TR1-MM-2 | `Given.*When.*Then` | Acceptance scenarios exist with Given/When/Then format | "Spec must contain acceptance scenarios (Given/When/Then format)" |
| TR1-MM-3 | `TR Gate Assessment` | Gate assessment section exists (backward compatibility) | "Spec must contain a TR Gate Assessment section" |
| TR1-MM-4 | `Feasibility` or `Risk Register` | Feasibility assessment or risk analysis present | "Spec must contain a feasibility assessment or risk register" |

Minimum required: 3 of 4 patterns must match for TR1 to pass.

### TR2_TR3 — Plan Gate

Must-Meet criteria: "Architecture reviewed, dependencies locked"

| Pattern ID | Regex Pattern | Meaning |
|-----------|---------------|---------|
| TR2-MM-1 | `Gate Readiness` | Gate readiness section exists |
| TR2-MM-2 | `Architecture Decision` or `Data Model` or `API Contract` or `Contracts` | Architecture or design artifacts present |
| TR2-MM-3 | `Constitution Check` | Constitution alignment verified |
| TR2-MM-4 | `WSJF Priority Score` or `WSJF` | WSJF prioritization present (IPD only) |

Minimum required: 3 of 4 patterns must match.

### TR4 — Development Gate

Must-Meet criteria: "DoD defined, CI configured"

| Pattern ID | Regex Pattern | Meaning |
|-----------|---------------|---------|
| TR4-MM-1 | `- \[.\] T\d{3,4}` | Task items with IDs exist |
| TR4-MM-2 | `Gate Completion Verification` | Gate checkpoint section exists |
| TR4-MM-3 | `Phase \d+` or `Phase 0` or `Phase 1` | Phase structure present |
| TR4-MM-4 | `Definition of Done` or `DoD` | DoD defined (IPD only) |

Minimum required: 3 of 4 patterns must match.

### TR4A — Gray Release / Quality Gate

Must-Meet criteria: Task completion verification

| Pattern ID | Regex Pattern | Meaning |
|-----------|---------------|---------|
| TR4A-MM-1 | `- \[[xX]\] T\d{3,4}` | Completed task checkboxes exist |
| TR4A-MM-2 | Completion ratio ≥ defined threshold | Sufficient tasks completed |
| TR4A-MM-3 | `Quality Summary` or `Quality Report` | Quality validation present |

Minimum required: 2 of 3 patterns must match.

### TR5 — Validation Gate

Must-Meet criteria: "Blocker/critical bugs = 0"

| Pattern ID | Regex Pattern | Meaning |
|-----------|---------------|---------|
| TR5-MM-1 | All prior gates `passed` in gate-status.json | All prerequisite gates verified |
| TR5-MM-2 | `Cross-artifact` or `Consistency` or `Analyze` | Cross-artifact consistency checked |
| TR5-MM-3 | `Test Report` or `Validation` or `Verification` | Validation evidence present |

Minimum required: 3 of 3 patterns must match.

### TR6 — Launch Gate (NEW)

Must-Meet criteria: "Deployment verified, ops handover complete"

| Pattern ID | Regex Pattern | Meaning |
|-----------|---------------|---------|
| TR6-MM-1 | All prior gates (TR0-TR5) `passed` in gate-status.json | All prerequisite gates verified |
| TR6-MM-2 | `Deployment Verif` or `Deploy.*verified` or `Release Notes` | Deployment verification evidence present |
| TR6-MM-3 | `Ops Handover` or `Operations.*Handover` or `Operational Readiness` | Ops handover documentation present |

Minimum required: 3 of 3 patterns must match.

## Should-Meet Validation Patterns (Advisory)

Should-Meet criteria are evaluated but do not block gate passage. They appear in the gate-check output as advisory results.

| Gate | Should-Meet Criterion | Assessment Method |
|------|----------------------|-------------------|
| TR1 | Market attractiveness > 8/10 | Look for `Market attractiveness` or `Market.*score` in spec; if not found, report "not assessed" |
| TR2_TR3 | Effort variance < 15% | Look for `Effort variance` or `variance.*15` in plan; if not found, report "not assessed" |
| TR4 | Velocity variance < 15% | Look for `Velocity` or `velocity variance` in tasks; if not found, report "not assessed" |
| TR5 | Beta NPS >= 8 | Look for `NPS` or `Beta.*feedback` or `beta NPS` in spec/analysis; if not found, report "not assessed" |
| TR6 | Training pass rate = 100% | Look for `Training.*pass` or `training.*100` in launch docs; if not found, report "not assessed" |

## Gate Check Output Format (Enhanced)

The gate-check script output is enhanced to include depth validation results and Should-Meet criteria:

```json
{
  "gate": "TR1",
  "status": "failed",
  "prior_gates": [
    {"gate": "TR0", "status": "passed", "evidence": "Constitution exists with Gate Criteria Reference section", "errors": ""}
  ],
  "current_gate": {
    "gate": "TR1",
    "status": "failed",
    "evidence": "Spec exists but fails depth validation",
    "errors": [
      "Must-Meet criterion not met: Spec must contain at least one user story with priority (pattern TR1-MM-1 not found in spec.md)",
      "Must-Meet criterion not met: Spec must contain acceptance scenarios (pattern TR1-MM-2 not found in spec.md)"
    ],
    "must_meet_details": [
      {"criterion": "User story headings", "pattern": "^###\\s+User Story", "matched": false, "artifact_path": "specs/009-foo/spec.md"},
      {"criterion": "Acceptance scenarios", "pattern": "Given.*When.*Then", "matched": false, "artifact_path": "specs/009-foo/spec.md"},
      {"criterion": "TR Gate Assessment section", "pattern": "TR Gate Assessment", "matched": true, "artifact_path": "specs/009-foo/spec.md"},
      {"criterion": "Feasibility assessment", "pattern": "Feasibility|Risk Register", "matched": false, "artifact_path": "specs/009-foo/spec.md"}
    ],
    "depth_validated": true
  },
  "should_meet": [
    {"criterion": "Market attractiveness > 8/10", "status": "not_assessed", "score": null}
  ],
  "errors": [
    "Must-Meet criterion not met: Spec must contain at least one user story with priority",
    "Must-Meet criterion not met: Spec must contain acceptance scenarios",
    "Must-Meet criterion not met: Spec must contain a feasibility assessment or risk register"
  ]
}
```

## Minimum Pass Threshold

A gate passes when:
1. All prior prerequisite gates have status `passed`
2. The minimum number of Must-Meet patterns match (see per-gate thresholds above)
3. No critical errors in the artifact files

A gate with `passed` status may still have advisory Should-Meet results that are `not_assessed` or `not_met` — these are informational and do not block passage.