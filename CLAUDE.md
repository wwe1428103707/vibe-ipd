<!-- SPECKIT START -->
For additional context about the current implementation plan,
read the plan at `specs/018-claude-code-workflow/plan.md`.
Design artifacts (research, data-model, contracts, quickstart) are in the same directory.
Feature: Claude Code Workflow Optimization — add `--integration claude-code` to `vipd init`, auto-generate Workflow scripts in `vipd-tasks`, and execute via Workflow tool in `vipd-implement`. Multi-agent parallel task execution.
Claude Code mode files: `.vipd/config.yml` (mode field), `.claude/templates/workflow-template.js`, `.claude/workflows/execute-tasks.wf.js` (auto-generated), `.vipd/mode.sh`/`.ps1`.
Commands added: `/vipd-config-mode set <standard|claude-code>`.
Gate status: TR4/TR4A implementation complete ✅ (27 tasks across 8 phases)
Next: /vipd-git-commit to commit changes or run /vipd-analyze for cross-artifact review
<!-- SPECKIT END -->
