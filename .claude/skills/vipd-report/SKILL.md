---
name: "vipd-report"
description: "Generate a static HTML report showing all TR gate check history and details."
argument-hint: "[--output <path>] [--gate <TR1|TR2_TR3|...>]"
metadata:
  author: "vibe-ipd"
  source: "specs/019-auto-gate-fix"
user-invocable: true
disable-model-invocation: false
---

## User Input

```text
$ARGUMENTS
```

Parse arguments:
- `--output <path>` — custom output path (optional, default: `specs/<current-feature>/vipd-report.html`)
- `--gate <ID>` — filter by gate ID (optional, e.g., `TR1`, `TR2_TR3`, `TR4`)

**Examples**:
- `/vipd-report` — generate report for current feature directory
- `/vipd-report --output docs/gate-report.html` — custom output path
- `/vipd-report --gate TR4` — show only TR4 gate history

## Execution

### Step 1: Run the generator

```powershell
.specify/scripts/powershell/generate-report.ps1 [-OutputPath <path>] [-Gate <ID>]
```

### Step 2: Report result

If successful, display the output path and suggest opening the file:

```
✅ Gate report generated: <path>
Open in browser to view: file:///<absolute-path>
```

## Data Source

- **Gate records**: `.specify/memory/gate-history.jsonl`
- **Report template**: `.claude/templates/report-template.html`
- **Gate overview**: `.specify/memory/gate-status.json`

## Related

- `/vipd-analyze` — Cross-artifact consistency analysis
- Gate records are automatically written by gate-check.ps1 / gate-record.ps1
