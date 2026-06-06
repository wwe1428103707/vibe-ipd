# Contract: Tooling Blueprint Agent PM Section

**Purpose**: Define the content to add to the Tooling Integration Blueprint docs.

## English Blueprint

**File**: `docs/ipd-transformation/03-tooling-integration-blueprint.md`

### New Section: "Spec Kit Agent Integration (Document-State Mode)"

Insert after "CI/CD Integration" section, before "Platform Alternatives":

```markdown
## Spec Kit Agent Integration (Document-State Mode)

In addition to Jira-based gate enforcement, the Spec Kit toolchain provides
native gate enforcement through its AI agent command system. This
"document-state mode" works without external tooling by having each
`/vipd-speckit-*` command perform pre-flight TR gate checks against the project's
own documentation.

### How It Works

1. **IPD Mode Detection**: Each command first checks if the project's
   constitution contains a "Gate Criteria Reference" section. If yes, IPD
   mode is active; if no, the project is SDD-only and gate checks are skipped.

2. **Deep Content Validation**: Instead of simple file-existence checks, each
   command performs deep content validation — verifying that required sections
   exist within the relevant documents (constitution, spec, plan, tasks).

3. **Gate Flow Enforcement**: Commands enforce sequential gate progression:
   - `/vipd-speckit-constitution` → TR0 (project setup)
   - `/vipd-speckit-specify`, `/vipd-speckit-clarify` → TR1 (concept)
   - `/vipd-speckit-checklist`, `/vipd-speckit-plan` → TR2/TR3 (plan/design)
   - `/vipd-speckit-tasks` → TR4 (development baseline)
   - `/vipd-speckit-implement` → TR4/TR4A (development)
   - `/vipd-speckit-analyze` → TR5 (validation)

### Comparison: Document-State vs Jira-Integrated

| Aspect | Document-State Mode | Jira-Integrated Mode |
|--------|-------------------|---------------------|
| External tools required | None | Jira Cloud Premium |
| Gate enforcement | Pre-flight command checks | Automation rules + field validators |
| Evidence collection | Document content analysis | Jira issue fields + webhooks |
| Dependency tracking | Cross-reference links | Advanced Roadmaps |
| Setup effort | None (built into Spec Kit) | Requires Jira configuration |
```

## Chinese Blueprint

**File**: `docs/ipd-transformation/zh/03-工具集成蓝图.md`

### Same content as English, translated to Chinese

The same section should appear in the Chinese blueprint, maintaining the
"中文名 (English Term)" convention for first-reference technical terms.
