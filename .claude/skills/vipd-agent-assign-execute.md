---
name: vipd-agent-assign-execute
description: Execute tasks by spawning the assigned agent for each task, with IPD TR4 gate validation
user-invocable: true
---

1. **Read agent-assignments.yml and tasks.md** from the feature directory.

2. **For each task**, identify the assigned agent and execute:
   - If `default` → implement directly in current context
   - If a named agent → load the agent's definition from `.claude/agents/<name>.md` and incorporate its expertise into the implementation

3. **TR4 gate validation** — After each task completes:
   - Verify success criteria from the spec are met
   - Document gate evidence
   - Flag any failures

4. **Track progress** — Update `tasks.md` with completion status and gate evidence.
