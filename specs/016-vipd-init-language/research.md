# Research: VIPD Init Language Option

**Date**: 2026-06-08 | **Plan**: [plan.md](plan.md)

## R1: Language Resource File Format

### Decision
Flat YAML key-value pairs using `section.key` dot notation for organization.

### Structure
```yaml
# lang/en.yml
init:
  welcome: "Welcome to vipd project initialization!"
  project_name: "Project name"
  language_select: "Select your preferred language"
  complete: "Initialization complete!"

error:
  network: "Network error: unable to reach GitHub."
  no_tool: "No supported tool found."
  invalid_lang: "Unsupported language '{code}'. Falling back to English."
```

### Rationale
- YAML is already used throughout the project (config files, gate config)
- `section.key` naming avoids key collisions and groups related messages
- Flat structure (no nesting) makes lookup trivial: `resource["init.welcome"]`
- Missing key → English fallback via Python dict `.get()` chain

## R2: Config File Priority Resolution

### Decision
Priority chain: `--lang` CLI flag > project `.vipd/config.yml` > user `~/.vipd/config.yml` > `en` default

### Resolution Algorithm
```
1. If --lang flag is provided on command → use it (no config update)
2. Else if .vipd/config.yml exists and has "language" key → use it
3. Else if ~/.vipd/config.yml exists and has "language" key → use it
4. Else → use "en" (default)
```

### Why Project Config Over User Config
- Project-level config is version-controlled and shared with the team
- User config is for personal preference override within a project
- This matches the common pattern (e.g., `.git/config` > `~/.gitconfig`)

## R3: Existing Config Conventions

### Decision
Create `.vipd/config.yml` as the project-level configuration file. The `language` key is the first configuration option.

### Current State
vipd currently has no centralized configuration mechanism. The `.vipd/` directory exists conceptually for future use. This feature creates it.

### Config Structure
```yaml
# .vipd/config.yml
language: zh  # or en, ja, etc.
```

## R4: Language Code Validation

### Decision
Whitelist-based validation. Only codes present in the `lang/` directory (as `<code>.yml` files) are accepted. Invalid codes trigger a fallback to `en` with a warning.

### Validation Flow
```
validate(code):
  if code in list_supported_languages():
    return code
  else:
    warn(f"Unsupported language '{code}'. Falling back to English.")
    return "en"
```

### Supported Languages at Launch
| Code | File | Display Name |
|------|------|-------------|
| `en` | `lang/en.yml` | English |
| `zh` | `lang/zh.yml` | 中文 (Chinese) |

## Summary of Decisions

| Area | Decision | Alternative Considered |
|------|----------|----------------------|
| Resource format | Flat YAML with dot-notation keys | Nested YAML (harder to lookup) |
| Config priority | CLI > project > user > default | CLI > user > project (less team-friendly) |
| Config location | `.vipd/config.yml` (new) | Embed in existing file (no existing file) |
| Language validation | Whitelist via directory scan | Hardcoded list (less extensible) |
