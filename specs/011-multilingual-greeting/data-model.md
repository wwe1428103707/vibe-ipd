# Data Model: Multilingual Greeting

**Phase**: Phase 1 | **Date**: 2026-06-07 | **Feature**: [spec.md](spec.md)

## Entity: GreetingTemplate

| Field | Type | Description | Constraints |
|-------|------|-------------|-------------|
| `language` | String | Human-readable language name | One of: English, Chinese, Japanese |
| `code` | String | Two-letter language code | One of: `en`, `zh`, `ja` |
| `template` | String | Greeting string with `<NAME>` placeholder | Must contain `<NAME>` substitution point |
| `fallback` | String | Pointer to default language | If not `en`, must fall back to `en` |

## Validation Rules

- Language code must be exactly 2 lowercase letters
- Only `en`, `zh`, `ja` are valid codes
- Unsupported code → fallback to `en` with stderr notice
- `<NAME>` placeholder is replaced literally (no sanitization)
