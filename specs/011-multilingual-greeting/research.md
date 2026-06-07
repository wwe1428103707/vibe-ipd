# Research: Multilingual Greeting Localization

**Phase**: Phase 0 | **Date**: 2026-06-07 | **Feature**: [Multilingual Greeting](spec.md)

## Research Tasks

### R-001: Determine Greeting Message Format

- **Decision**: Use a templated greeting string per language, with `<NAME>` as the substitution point
- **Rationale**: Simplest approach — no gettext, no i18n library, just `case` statements with embedded strings.
- **Alternatives considered**: gettext (`msgfmt`) — overkill for 3 languages; external files — makes the script dependent on file locations.

### R-002: Determine Name Localization Handling

- **Decision**: Pass the name through verbatim — no transliteration or adjustment per language
- **Rationale**: Names are often kept in their original form regardless of the greeting language.
- **Alternatives considered**: Transliterating names per language — no reliable way in pure bash; adding honorifics per culture (e.g., "さん" in Japanese for the `--name` parameter) — adds complexity without clear value instruction.

### R-003: Supported Language Greeting Strings

| Language | Code | Greeting Template |
|----------|------|-------------------|
| English | `en` | `Hello, <NAME>! Welcome to the IPD-Agile toolchain validation.` |
| Chinese (Simplified) | `zh` | `你好，<NAME>！欢迎来到IPD-Agile工具链验证。` |
| Japanese | `ja` | `こんにちは、<NAME>さん！IPD-Agileツールチェーン検証へようこそ。` |
