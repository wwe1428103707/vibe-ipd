# Research: VIPD Command Prefix Renaming

## Affected Files Inventory

| Location | Count | Pattern |
|----------|-------|---------|
| `.claude/skills/vipd-speckit-*/SKILL.md` | 18 | Copy dir + update internal `/vipd-speckit-` refs |
| `docs/ipd-transformation/*.md` | 7 | Replace all `/vipd-speckit-` with `/vipd-speckit-` |
| `docs/ipd-transformation/zh/*.md` | 7 | Same as above |
| `.specify/memory/constitution.md` | 1 | Dev Workflow table |
| `.specify/templates/*-template.md` | 4 | Command references |
| `specs/001-*/**/*.md` | ~14 | Spec artifacts |
| `specs/002-*/**/*.md` | ~14 | Spec artifacts |
| `specs/003-*/**/*.md` | ~12 | Spec artifacts |
| `specs/004-*/**/*.md` | ~7 | This feature |
| `.specify/extensions.yml` | 1 | Hook command names |

## Replacement Rules

| Context | Old | New |
|---------|-----|-----|
| Command invocation | `/vipd-speckit-` | `/vipd-speckit-` |
| Dotted config name | `speckit.` | `vipd.speckit.` |
| Skill directory name | `speckit-` | `vipd-speckit-` |
| Documentation references | `/vipd-speckit-` | `/vipd-speckit-` |
