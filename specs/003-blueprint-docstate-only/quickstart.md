# Quickstart: Simplifying the Tooling Blueprint

**Branch**: `003-blueprint-docstate-only`

## What to Do

1. **Backup the existing files** (git handles this — they're committed)
2. **Rewrite English blueprint** at `docs/ipd-transformation/03-tooling-integration-blueprint.md`
   - Remove: Issue Hierarchy, Workflow States, Automation Rules (3 sections),
     Dependency Management (Advanced Roadmaps), CI/CD Integration
   - Rewrite: Overview to focus on docstate
   - Keep: Spec Kit Agent Integration, Platform Alternatives (minimal), Cross-References
3. **Rewrite Chinese blueprint** at `docs/ipd-transformation/zh/03-工具集成蓝图.md`
   - Same structural changes as English
4. **Update cross-references** in `docs/ipd-transformation/02-command-template-redesign-guide.md`
5. **Verify**: Zero Jira references remain in either blueprint

## Verification

```bash
# Check for Jira references in blueprints
grep -i "jira\|advanced roadmap\|webhook\|automation rule" docs/ipd-transformation/03*.md

# Check line count
wc -l docs/ipd-transformation/03*.md
# Should be ≤90 lines (was 218)
```
