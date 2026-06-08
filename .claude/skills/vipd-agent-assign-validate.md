---
name: vipd-agent-assign-validate
description: Validate that all agent assignments are correct and agents exist, with IPD RACI compliance check
user-invocable: true
---

1. **Read agent-assignments.yml** from the feature directory.

2. **For each assigned agent**, verify the agent definition exists:
   - Check `.claude/agents/*.md` (project-level)
   - Check `~/.claude/agents/*.md` (user-level)

3. **RACI compliance check** — Ensure:
   - Every task has at least one accountable (A) agent
   - IPD gate-critical tasks have appropriate role coverage
   - No conflicting agent responsibilities

4. **Report** — Output a pass/fail summary, listing any missing agents or compliance warnings.
