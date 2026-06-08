---
name: vipd-agent-assign-validate
description: Validate that all agent assignments are correct and agents exist, with IPD RACI compliance check
---

1. **Read Assignments**: Load `agent-assignments.yml` from the current feature directory.

2. **Verify Agents Exist**: For each assigned agent, confirm the definition exists:
   - Check `.claude/agents/*.md` (project-level)
   - Check `~/.claude/agents/*.md` (user-level)

3. **RACI Compliance Check**: Verify:
   - Each task has at least one accountable (A) agent
   - Critical IPD gate tasks have appropriate role coverage
   - No conflicting agent responsibilities

4. **Report**: Output a validation summary with pass/fail for each check.
