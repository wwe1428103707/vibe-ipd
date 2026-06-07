# Data Model: Chinese Documentation Translation

**Plan**: [plan.md](plan.md) | **Date**: 2026-06-07

## Document Catalog

Maps each English source document to its Chinese translation path.

### Core Documentation (Documentation Section in README)

| Source (English) | Translation (Chinese) | Priority | Status |
|---|---|---|---|
| `docs/quickstart.md` | `docs/zh/quickstart.md` | P1 | Pending |
| `docs/installation.md` | `docs/zh/installation.md` | P1 | Pending |
| `docs/concepts/sdd.md` | `docs/zh/concepts/sdd.md` | P3 | Pending |
| `docs/reference/overview.md` | `docs/zh/reference/overview.md` | P2 | Pending |
| `docs/reference/core.md` | `docs/zh/reference/core.md` | P2 | Pending |
| `docs/reference/authentication.md` | `docs/zh/reference/authentication.md` | P2 | Pending |
| `docs/reference/extensions.md` | `docs/zh/reference/extensions.md` | P2 | Pending |
| `docs/reference/integrations.md` | `docs/zh/reference/integrations.md` | P2 | Pending |
| `docs/reference/presets.md` | `docs/zh/reference/presets.md` | P2 | Pending |
| `docs/reference/workflows.md` | `docs/zh/reference/workflows.md` | P2 | Pending |

### Pre-existing Translations (link only, no new translation needed)

| Source | Translation Location | Action |
|---|---|---|
| `docs/ipd-transformation/` (all files) | `docs/ipd-transformation/zh/` | Link from README.zh.md only |

### Nice-to-Have (if scope permits)

| Source (English) | Translation (Chinese) | Priority |
|---|---|---|
| `docs/index.md` | `docs/zh/index.md` | Optional |
| `docs/upgrade.md` | `docs/zh/upgrade.md` | Optional |
| `docs/local-development.md` | `docs/zh/local-development.md` | Optional |
| `docs/install/uv.md` | `docs/zh/install/uv.md` | Optional |
| `docs/install/pipx.md` | `docs/zh/install/pipx.md` | Optional |
| `docs/install/one-time.md` | `docs/zh/install/one-time.md` | Optional |
| `docs/install/air-gapped.md` | `docs/zh/install/air-gapped.md` | Optional |
| `docs/README.md` | `docs/zh/README.md` | Optional |

## Entities

### DocumentationFile (English Source)
| Attribute | Type | Description |
|---|---|---|
| `sourcePath` | String | Relative path from repo root, e.g., `docs/quickstart.md` |
| `title` | String | Document title (from H1 heading) |
| `lineCount` | Integer | Number of lines |
| `section` | Enum | `quickstart`, `installation`, `concepts`, `reference`, `ipd-transformation`, `community` (excluded), `other` |

### ChineseTranslation
| Attribute | Type | Description |
|---|---|---|
| `translationPath` | String | Relative path under `docs/zh/`, e.g., `docs/zh/quickstart.md` |
| `sourcePath` | String (FK) | References the English source `DocumentationFile.sourcePath` |
| `lastSynced` | Date | Date the translation was last aligned with the English source |

### README.zh.md
| Attribute | Type | Description |
|---|---|---|
| `path` | String | `README.zh.md` |
| `documentationLinks` | Array of Link | Each link has `label` (Chinese display text), `target` (path to Chinese translation or `docs/ipd-transformation/zh/`) |

## Link Mapping Rules

### English → Chinese path transformation
For any source file under `docs/<section>/<file>.md`:
- Translation goes to `docs/zh/<section>/<file>.md`
- Exception: `docs/ipd-transformation/` → already at `docs/ipd-transformation/zh/`

### Language toggle links
Each Chinese document MUST include at the top:
```markdown
> [English](<relative-path-to-english-original>) · **[中文](<relative-path-to-self>)**
```

Each English document SHOULD include at the top (if Chinese exists):
```markdown
> **[English](<relative-path-to-self>)** · [中文](<relative-path-to-chinese>)
```

### Relative cross-references
When a Chinese document links to another documentation page:
- If the target has a Chinese translation → point to the Chinese path
- If the target has no Chinese translation → point to the English path (with graceful fallback per FR-011)
