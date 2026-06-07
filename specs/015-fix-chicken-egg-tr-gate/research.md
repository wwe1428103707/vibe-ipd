# Research: Fix TR Gate Chicken-Egg Dependency

**Date**: 2026-06-08 | **Plan**: [plan.md](plan.md)

## R1: tr-criteria.yml Schema Design

### Decision
YAML format with hierarchical gate structure, each criterion having: ID, gate reference, type (Must-Meet/Should-Meet), phase ownership, description, and dependency list.

### Schema Structure
```yaml
gate_criteria:
  - id: "TR2-MM-001"
    gate: "TR2/TR3"
    type: "Must-Meet"
    title: "Architecture reviewed"
    owning_phase: "Plan"
    description: "Architecture design has been reviewed and approved"
    depends_on: []  # criteria IDs this depends on
  - id: "TR2-SM-001"
    gate: "TR2/TR3"
    type: "Should-Meet"
    title: "Effort variance < 15%"
    owning_phase: "Task"
    description: "Effort estimates are within 15% of actuals"
    depends_on: ["TR2-MM-001"]  # requires architecture clarity first
```

### Rationale
- YAML chosen over JSON for human readability (the primary authors are PDT members, not machines)
- `owning_phase` field makes phase ownership explicit — the core fix for the chicken-and-egg problem
- `depends_on` list enables the cycle detection algorithm
- Sequential IDs follow the scheme established during `/vipd-clarify`

## R2: Cycle Detection Algorithm

### Decision
Simple DFS-based cycle detection with visited set tracking. Tarjan's SCC is overkill for < 50 nodes.

### Algorithm
```
function hasCycles(criteria):
  unvisited = set(criteria.ids)
  visiting = set()
  visited  = set()

  for each id in unvisited:
    if dfs(id):
      return True, cycle_path
  return False, []

function dfs(id):
  move id from unvisited to visiting
  for each dep in criteria[id].depends_on:
    if dep in visiting:
      return True  # cycle found: dep -> ... -> id -> dep
    if dep in unvisited:
      if dfs(dep):
        return True
  move id from visiting to visited
  return False
```

### Rationale
- Linear complexity O(N + E) for N criteria and E dependency edges
- Produces the cycle path for reporting (FR-004 requirement)
- No external library dependencies

## R3: Audit Log Format

### Decision
JSON Lines (`.jsonl`), one JSON object per line, append-only.

### Schema (per-entry)
```json
{
  "timestamp": "2026-06-08T10:00:00+08:00",
  "actor": "YuFJ",
  "event_type": "gate_criteria_status_change",
  "feature": "015-fix-chicken-egg-tr-gate",
  "gate": "TR2/TR3",
  "criterion_id": "TR2-MM-001",
  "from_status": "pending",
  "to_status": "passed",
  "rationale": "Architecture review completed and approved"
}
```

### Event Types
- `gate_criteria_status_change` — any criterion status transition
- `gate_criteria_config_change` — edits to `tr-criteria.yml`
- `gate_manual_override` — manual gate override action
- `gate_verdict` — overall gate verdict issued
- `deferred_item_resolved` — deferred item verified at later gate

### Rationale
- JSON Lines is append-only — no need to read/rewrite entire file
- Standard format across the project (other scripts use JSON)
- No rotation needed at projected volume (< 1000 entries per feature lifecycle)

## R4: Configuration Validation

### Decision
PowerShell-native validation with `ConvertFrom-Json` + schema comparison functions. Python `jsonschema` as an optional enhancement.

### Approach
1. YAML files parsed via `powershell-yaml` module if available, or fallback to `ConvertFrom-Json` after a `ConvertTo-Json` pass
2. JSON schemas (`.schema.json` files) define the expected structure
3. PowerShell functions validate required fields, types, and allowed values
4. Validation errors are reported with field paths for easy debugging

### Rationale
- Minimizes external dependencies — everything works out of the box with PowerShell 7+
- The schema files in `contracts/` serve dual purpose: documentation and validation
- Python fallback only if PowerShell-native parsing proves insufficient

## Summary of Decisions

| Area | Decision | Alternative Considered |
|------|----------|----------------------|
| Criteria schema format | YAML | JSON (less readable) |
| Cycle detection | DFS with visited tracking | Tarjan's SCC (overkill) |
| Audit log format | JSON Lines (`.jsonl` append-only) | Single JSON array (requires rewrite) |
| Config validation | PowerShell-native | Python `jsonschema` (optional) |
