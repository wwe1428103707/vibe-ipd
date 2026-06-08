---
name: vipd-agent-assign-assign
description: Scan available Claude Code agents and assign them to tasks in tasks.md, with IPD PDT role awareness and RACI matrix compliance
---

1. **Load Tasks**: Read `tasks.md` from the current feature directory. Parse each task and extract Task ID, description, and file paths.

2. **Scan Agent Definitions**: Discover all available Claude Code agent definition files:
   - Project-level: `.claude/agents/*.md` in the repository root
   - User-level: `~/.claude/agents/*.md`
   Parse YAML frontmatter to extract agent `name` and `description`.

3. **Auto-Match Agents to Tasks**: For each task, analyze its description and file paths against each agent's capabilities:
   - File path patterns (e.g., `src/api/` → API agent, `tests/` → test agent)
   - Task keywords ("Create model" → backend, "Write test" → test-writer)
   - IPD PDT roles (LPDT, PO, System Architect, QA Lead, DevOps Lead)

4. **Write Assignments**: Generate `agent-assignments.yml` with the full assignment table.

5. **Confirm**: Present the assignments to the user for acceptance or modification.
