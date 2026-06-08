---
name: vipd-agent-assign-execute
description: Execute tasks by spawning the assigned agent for each task, with IPD TR4 gate validation
---

1. **Load Assignments**: Read `agent-assignments.yml` and `tasks.md` from the current feature directory.

2. **Execute Each Task**: For each task, spawn the assigned agent:
   - Load the agent's system prompt from `.claude/agents/<agent-name>.md`
   - Pass the task description, file paths, and context
   - Set task-specific instructions

3. **TR4 Gate Validation**: After each task completes:
   - Verify success criteria from the spec are met
   - Document gate evidence
   - Flag any failures

4. **Track Progress**: Update `tasks.md` with completion status and gate evidence.
