# Data Model: VIPD Init Language Option

**Date**: 2026-06-08 | **Plan**: [plan.md](plan.md)

## Entities

### LanguageConfig

Represents the language setting in the vipd configuration. Resolved via priority chain.

| Priority | Source | Example | Description |
|----------|--------|---------|-------------|
| 1 (highest) | `--lang` CLI flag | `vipd init --lang zh` | Per-command override, does NOT persist to config |
| 2 | `.vipd/config.yml` | `language: zh` | Project-level config (version-controlled) |
| 3 | `~/.vipd/config.yml` | `language: zh` | User-level global config |
| 4 (fallback) | Default | `en` | Hardcoded default when no config exists |

**Config file structure** (`.vipd/config.yml`):
```yaml
language: zh
```

**Validation rules**:
- Value must be a supported language code (present in `lang/<code>.yml`)
- Invalid values: fall back to `en` with a warning
- Missing key: treated as `en` default

### LanguageResource

A collection of user-facing message strings in a specific language.

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `file` | string | ✅ | Path: `lang/<code>.yml` |
| `code` | string | ✅ | Language code, e.g., `en`, `zh` |
| `display_name` | string | ✅ | Human-readable name, e.g., "English", "中文" |
| `keys` | map | ✅ | Flat key-value pairs using `section.key` dot notation |

**File format** (`lang/en.yml`):
```yaml
init:
  welcome: "Welcome to vipd project initialization!"
error:
  network: "Network error."
```

**Key naming convention**: `{section}.{key}` where section groups related messages.

**Fallback behavior**:
- When a key is missing in the selected language → look up in `lang/en.yml`
- When the key is also missing in English → return the key name itself with `[MISSING]` prefix

### LanguageRegistry

The set of supported languages, discovered at runtime.

**Discovery mechanism**: Scan the `lang/` directory for all `*.yml` files. Each file's stem (without extension) is a language code.

**Registry entry fields**:
| Field | Type | Description |
|-------|------|-------------|
| `code` | string | Language code, from filename |
| `display_name` | string | Human-readable name, from `display_name` key in the resource file |
| `file` | string | Path to the resource file |

**Default entries** (at launch):
| Code | Display Name | File |
|------|-------------|------|
| `en` | English | `lang/en.yml` |
| `zh` | 中文 | `lang/zh.yml` |

## File Inventory

| File | Format | Location | Purpose |
|------|--------|----------|---------|
| `config.yml` | YAML | `.vipd/` or `~/.vipd/` | Language setting storage |
| `en.yml` | YAML | `lang/` | English string resources |
| `zh.yml` | YAML | `lang/` | Chinese string resources |
| `config-schema.json` | JSON Schema | `contracts/` | Config file validation |
| `lang-resource-schema.json` | JSON Schema | `contracts/` | Language resource file validation |

## Resolution Flow

```
User runs: vipd <command> [--lang <code>]
                     │
                     ▼
            ┌─────────────────┐
            │ --lang provided?│
            └───────┬─────────┘
               Yes   │   No
               │     ▼
               │   ┌─────────────────┐
               │   │ .vipd/config.yml│
               │   │ has language?   │
               │   └───────┬─────────┘
               │      Yes   │   No
               │      │     ▼
               │      │   ┌─────────────────┐
               │      │   │~/.vipd/config.yml
               │      │   │ has language?   │
               │      │   └───────┬─────────┘
               │      │      Yes   │   No
               │      │      │     ▼
               │      │      │   ┌──────────┐
               │      │      │   │ default  │
               │      │      │   │ "en"     │
               │      │      │   └──────────┘
               ▼      ▼      ▼      ▼
            ┌──────────────────────────┐
            │ Validate: supported?     │
            └───────┬──────────────────┘
               Yes   │   No
               │     ▼
               │   ┌──────────────────┐
               │   │ Fall back to "en"│
               │   │ + warning        │
               │   └──────────────────┘
               ▼
         ┌────────────────────┐
         │ Load lang/<code>.yml│
         │ for all messages   │
         └────────────────────┘
```
