---
name: vipd-agent-assign-assign
description: Scan available Claude Code agents and assign them to tasks in tasks.md, with IPD PDT role awareness and RACI matrix compliance
user-invocable: true
---

1. **Load tasks.md** — Read `tasks.md` from the current feature directory. Extract all task IDs, descriptions, file paths, and dependencies.

2. **Scan agent definitions** — Discover available Claude Code agent files:
   - Project-level: `.claude/agents/*.md` in repo root
   - User-level: `~/.claude/agents/*.md`
   - Parse YAML frontmatter for agent `name` and `description`

3. **Auto-match agents to tasks** — For every task, pick the best-fit agent based on:
   - File path patterns (e.g. `src/api/` → API agent)
   - Task keywords ("Create model" → backend, "Write test" → test-writer)
   - IPD PDT roles (LPDT, PO, Architect, QA Lead, DevOps Lead)

4. **Write agent-assignments.yml** — Generate the file in the feature directory with the full assignment table.

5. **Confirm with user** — Show the assignment table and ask for acceptance or modification before saving.
