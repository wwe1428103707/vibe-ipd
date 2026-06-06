# Plan Addendum: Backward-Compatible Wrapper Rewrite

**Context**: The vipd prefix rename (T001–T018) created `vipd-speckit-*` copies
but left the original `speckit-*` files as full copies containing old `/speckit-*`
references. This addendum rewrites the originals as thin wrappers.

## Scope

Rewrite all 18 `speckit-*` skill files to contain only a redirect instruction
to the corresponding `vipd-speckit-*` skill, instead of the full duplicated content.

## Approach

Each `speckit-*/SKILL.md` will become:

```markdown
---
name: "speckit-<name>"
description: "[VIPD backward-compatible wrapper] Delegates to vipd-speckit-<name>"
---

This command has been renamed. Please use `/vipd-speckit-<name>` instead.

For backward compatibility, this wrapper redirects to the new command:

> **Redirect**: See `.claude/skills/vipd-speckit-<name>/SKILL.md` for the full implementation.
```

## Files to Modify

18 files matching `.claude/skills/speckit-*/SKILL.md`

## Rationale

- Reduces maintenance burden (no duplicated content to keep in sync)
- Clear deprecation message guides users to the new prefix
- Backward compatibility is preserved (invoking the old name shows guidance)
