# Contract: Link Mapping & Translation Patterns

**Plan**: [plan.md](../plan.md) | **Date**: 2026-06-07

## Language Toggle Pattern

Each bilingual document pair MUST include a language toggle at the top.

### Chinese translation document
```markdown
> [English](<path-to-english-original>) · **[中文](.)**
```

Examples:
- `docs/zh/quickstart.md`: `> [English](../quickstart.md) · **[中文](.)**`
- `docs/zh/reference/core.md`: `> [English](../../reference/core.md) · **[中文](.)**`

### English source document (after Chinese translation exists)
```markdown
> **[English](.)** · [中文](<path-to-chinese-translation>)
```

Examples:
- `docs/quickstart.md`: `> **[English](.)** · [中文](zh/quickstart.md)`
- `docs/reference/core.md`: `> **[English](.)** · [中文](../zh/reference/core.md)`

## Language Toggle Link Map

Full mapping of language toggle links for all in-scope documents:

| English Source | Chinese Translation | EN→ZH Link | ZH→EN Link |
|---|---|---|---|
| `docs/quickstart.md` | `docs/zh/quickstart.md` | `zh/quickstart.md` | `../quickstart.md` |
| `docs/installation.md` | `docs/zh/installation.md` | `zh/installation.md` | `../installation.md` |
| `docs/concepts/sdd.md` | `docs/zh/concepts/sdd.md` | `../zh/concepts/sdd.md` | `../../concepts/sdd.md` |
| `docs/reference/overview.md` | `docs/zh/reference/overview.md` | `../zh/reference/overview.md` | `../../reference/overview.md` |
| `docs/reference/core.md` | `docs/zh/reference/core.md` | `../zh/reference/core.md` | `../../reference/core.md` |
| `docs/reference/authentication.md` | `docs/zh/reference/authentication.md` | `../zh/reference/authentication.md` | `../../reference/authentication.md` |
| `docs/reference/extensions.md` | `docs/zh/reference/extensions.md` | `../zh/reference/extensions.md` | `../../reference/extensions.md` |
| `docs/reference/integrations.md` | `docs/zh/reference/integrations.md` | `../zh/reference/integrations.md` | `../../reference/integrations.md` |
| `docs/reference/presets.md` | `docs/zh/reference/presets.md` | `../zh/reference/presets.md` | `../../reference/presets.md` |
| `docs/reference/workflows.md` | `docs/zh/reference/workflows.md` | `../zh/reference/workflows.md` | `../../reference/workflows.md` |

## README.zh.md Documentation Links

Current README.zh.md links (in the Documentation / 文档 section):

| Current Link Target | Updated Target |
|---|---|
| `./docs/quickstart.md` | `./docs/zh/quickstart.md` |
| `./docs/installation.md` | `./docs/zh/installation.md` |
| `./docs/concepts/` | `./docs/zh/concepts/sdd.md` |
| `./docs/ipd-transformation/` | `./docs/ipd-transformation/zh/README.md` |
| `./docs/reference/` | `./docs/zh/reference/overview.md` |
| `./docs/community/` | Remove from Documentation section (out of scope) |

## Cross-Reference Rewriting

When a Chinese document contains a relative link to another documentation page:
1. Check if the target has a Chinese translation in `data-model.md`
2. If yes: rewrite link to point to Chinese version
3. If no: keep link pointing to English version
4. Preserve any anchor fragments (#section) as-is

## Code Block Preservation Contract

During translation, any content within fenced code blocks (```) or inline code (`) MUST remain:
- **Untranslated**: Code, commands, configuration values, variable names
- **Preserved exactly**: Whitespace, comments (even if in English)
- **Relative paths**: Update to `docs/zh/` equivalents if they reference other docs
