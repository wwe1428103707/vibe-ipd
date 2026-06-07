# Research: Document-State Tooling

## Existing Script Patterns

The `.specify/scripts/powershell/` directory contains these patterns:

| Pattern | Usage | Reference |
|---------|-------|-----------|
| `Get-RepoRoot` | Find project root via `.specify/` marker | common.ps1 |
| `ConvertFrom-Json` / `ConvertTo-Json` | JSON serialization for script output | check-prerequisites.ps1 |
| `Test-Path` | File existence checks | All scripts |
| `Select-String` | Content pattern matching (like grep) | common.ps1 |
| JSON output to stdout | Machine-parseable output | check-prerequisites.ps1 |

## Existing Gate Check Logic (In-Skill)

Each skill file (vipd-constitution, vipd-specify, etc.) has inline gate check logic:

1. **Mode detection**: Check if `.specify/memory/constitution.md` exists AND contains "Gate Criteria Reference" heading
2. **Deep validation**: Check specific document sections exist
3. **Status update**: Write to `.specify/memory/gate-status.json`
4. **Format**: `Select-String -Path $path -Pattern "Gate Criteria Reference" -Quiet` for content matching

## Design Decisions

1. **PowerShell primary**: All existing tooling is PowerShell. New gate utilities follow the same pattern.
2. **No Bash in v1**: Cross-platform Bash scripts are deferred to reduce scope. The project currently targets Windows (PowerShell only).
3. **JSON contract**: All utilities accept `-Json` flag for machine output, consistent with existing scripts.
4. **Error handling**: Return exit code 1 on failure, 0 on success, with error text on stderr.
5. **Mode detection** via `Select-String` for header matching is already proven in existing patterns.

### Existing Gate Content Checks (Consolidated)

| Gate | Check | Document | Pattern |
|------|-------|----------|---------|
| TR0 | Constitution exists + Gate Criteria Reference | constitution.md | File exists + heading match |
| TR0 (update) | Gate Criteria Reference not removed | constitution.md | Heading match |
| TR1 | Spec exists + TR Gate Assessment | spec.md | File exists + heading match |
| TR2/TR3 | Plan exists + Gate Readiness | plan.md | File exists + heading match |
| TR4 | Tasks exist + Gate Completion Verification | tasks.md | File exists + checkpoint match |
| TR4A | Implementation complete + quality indicators | tasks.md | Checkbox completion check |
| TR5 | All prior gates passed | gate-status.json | JSON field check |

## JSON Schema (gate-status.json)

```json
{
  "ipd_mode": true,
  "last_updated": "2026-06-06",
  "gates": {
    "TR0": {
      "status": "passed|pending|failed|skipped",
      "evidence": "string|null",
      "date": "YYYY-MM-DD|null"
    }
  }
}
```
