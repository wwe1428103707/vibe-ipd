# Feature Specification: Document-State Tooling Implementation

**Feature Branch**: `006-implement-docstate-tools`

**Created**: 2026-06-06

**Status**: Draft

**Input**: User description: "实现006-implement-docstate-tools — implement document-state mode gate checking tools from the tooling integration blueprint"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Automated Gate Check Script (Priority: P1)

As an IPD toolkit user, I want a reusable gate check script that each `/vipd-speckit-*` command can invoke, so that gate validation logic is centralized rather than duplicated across 8 skill files.

**Why this priority**: Currently each skill file has inline gate check logic. Centralizing reduces duplication and ensures consistent gate behavior.

**Independent Test**: The script can be invoked standalone with a TR gate identifier and returns pass/fail with evidence.

**Acceptance Scenarios**:
1. **Given** the gate check script exists, **When** invoked with `check-gate TR1`, **Then** it verifies TR0 passed + spec exists with TR Gate Assessment section.
2. **Given** IPD mode is inactive (no constitution), **When** any gate check is invoked, **Then** it returns "SDD mode — skip" without error.
3. **Given** a prior gate has not passed, **When** a downstream gate check is invoked, **Then** it returns the specific unmet criteria.

---

### User Story 2 - Centralized Gate Status Manager (Priority: P1)

As an IPD toolkit user, I want a reusable gate status update utility that reads and writes `.specify/memory/gate-status.json`, so that gate evidence recording is consistent across all commands.

**Why this priority**: Currently each skill has its own inline logic for updating gate status. A single utility prevents format drift.

**Independent Test**: Running `record-gate TR1 passed "Spec created"` updates the JSON file correctly.

**Acceptance Scenarios**:
1. **Given** the status manager utility exists, **When** invoked with a gate ID, status, and evidence, **Then** the JSON file is updated atomically.
2. **Given** the JSON file is missing or corrupt, **When** the utility is invoked, **Then** it creates a fresh file with reasonable defaults.
3. **Given** the utility runs, **When** the update is successful, **Then** it outputs the new gate status summary.

---

### User Story 3 - IPD Mode Detection Utility (Priority: P2)

As an IPD toolkit user, I want a simple mode detection script that checks whether the project has an IPD-enhanced constitution, so that commands can quickly determine whether to run gate checks.

**Why this priority**: Mode detection is the first step in every gate check. Centralizing it avoids file-read duplication.

**Independent Test**: Running `detect-ipd-mode` returns `true` or `false` based on constitution content.

**Acceptance Scenarios**:
1. **Given** the constitution exists with "Gate Criteria Reference" section, **When** detection runs, **Then** it returns `{"ipd_mode": true}`.
2. **Given** no constitution exists, **When** detection runs, **Then** it returns `{"ipd_mode": false}`.
3. **Given** the constitution exists but without Gate Criteria Reference, **When** detection runs, **Then** it returns `{"ipd_mode": false}`.

---

### Edge Cases

- What if `.specify/` directory structure is missing? Utilities should report clear setup instructions.
- What if multiple concurrent commands try to update gate status? Use file-locking or atomic writes.
- What if the gate evidence text is very long? Truncate at a reasonable limit (e.g., 500 chars).

## TR Gate Assessment *(IPD only)*

- **Applicable TR Gates**: TR1 (Concept — spec defines the tooling architecture)
- **Risk Level**: Low
- **Gate Evidence Required**: Utility scripts created and testable via CLI invocation

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: System MUST provide a `check-gate` script that accepts a TR gate identifier (e.g., `TR0`, `TR1`, `TR2_TR3`) and returns structured pass/fail with evidence.
- **FR-002**: `check-gate` MUST verify all prior gates recursively (e.g., checking TR3 also checks TR0-TR2).
- **FR-003**: `check-gate` MUST support a `--json` output mode for machine parsing.
- **FR-004**: System MUST provide a `record-gate` script that updates `.specify/memory/gate-status.json` with status, evidence, and date.
- **FR-005**: `record-gate` MUST atomically update the JSON file (create if missing, validate before write).
- **FR-006**: System MUST provide a `detect-ipd-mode` script that returns `{"ipd_mode": true/false}`.
- **FR-007**: `detect-ipd-mode` MUST check for constitution file existence AND "Gate Criteria Reference" section content.
- **FR-008**: All utility scripts MUST support `--help` flag with usage documentation.
- **FR-009**: Utility scripts SHOULD be invocable from PowerShell (primary Windows environment) and Bash.

### Key Entities

- **Gate Check Script**: A CLI tool that performs deep content validation against project documents to determine gate pass/fail status.
- **Gate Status Manager**: A JSON file read/write utility for `.specify/memory/gate-status.json`.
- **Mode Detector**: A content-inspection script that checks constitution sections for IPD mode activation.
- **Gate Evidence**: Structured information about why a gate passed or failed, including document references.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: All 3 utility scripts are invocable from command line with `--help` flag within 1 second.
- **SC-002**: `check-gate TR1` correctly verifies TR0 passed status before checking TR1 criteria.
- **SC-003**: `record-gate` updates `gate-status.json` and the output matches expected JSON schema.
- **SC-004**: `detect-ipd-mode` correctly distinguishes IPD vs SDD-only projects in under 500ms.

## Assumptions

- Scripts will be written in a cross-platform language (PowerShell + Bash dual implementation, or Node.js).
- The existing `.specify/scripts/powershell/` directory is the home for PowerShell variants.
- Gate check logic currently inline in skill files will be refactored to call these utilities.
- JSON schema for gate-status.json is stable (defined by current implementation).

## Risk Register *(IPD only)*

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| PowerShell-only scripts break on Linux/macOS | M | M | Provide equivalent Bash scripts or use Node.js |
| Refactoring skill files to use utilities breaks existing gate checks | H | L | Write tests for each utility before refactoring skills |
| Atomic JSON write conflicts with concurrent commands | M | L | Use temp-file + rename pattern for atomic writes |
