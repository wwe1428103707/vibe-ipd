# Research: VIPD Versioning & Docs Preparation

**Date**: 2026-06-08 | **Plan**: [plan.md](plan.md)

## R1: Version File Schema

### Decision
`.vipd/version.yml` — YAML format with two fields.

### Structure
```yaml
# .vipd/version.yml
vipd_version: "1.0.0"
speckit_version: "0.9.3.dev0"
```

### Rationale
- Consistent with existing `.vipd/config.yml` pattern
- YAML is human-readable and machine-parseable
- Single source of truth — no hardcoded versions elsewhere
- Easy to bump with simple file edit or `sed`

## R2: `vipd --version` Display Format

### Decision
Single-line output showing both versions clearly labeled.

### Format
```
vipd 1.0.0 (speckit 0.9.3.dev0)
```

### Rationale
- Compact enough for CLI usage
- Both versions visible at once — prevents confusion
- Common convention (many tools show their version + dependency versions)

### Implementation
A small shell script `vipd` at repo root:
```bash
#!/usr/bin/env bash
VIPD_DIR="$(cd "$(dirname "$0")/.vipd" && pwd)"
if [ -f "$VIPD_DIR/version.yml" ]; then
  VIPD_VER=$(grep 'vipd_version' "$VIPD_DIR/version.yml" | awk '{print $2}' | tr -d '"')
  SPECKIT_VER=$(grep 'speckit_version' "$VIPD_DIR/version.yml" | awk '{print $2}' | tr -d '"')
  echo "vipd $VIPD_VER (speckit $SPECKIT_VER)"
else
  echo "vipd unknown (speckit unknown)"
fi
```

## R3: CHANGELOG Structure

### Decision
Follow [Keep a Changelog](https://keepachangelog.com) format.

### Structure
```markdown
# Changelog

## [1.0.0] - 2026-06-08

### Added
- Feature 001-017: Complete IPD toolkit with spec-first workflow
```

### Release Grouping
- **v1.0.0**: Features 001-017 (all current features)
- Future releases organized by MAJOR.MINOR.PATCH

## R4: README Content Audit

### Required Sections (in order)
1. Title + Badge (vipd version)
2. Description — what vipd is and why it exists
3. Prerequisites — uv/pipx, git, Claude Code
4. Quick Install — one-liner setup
5. Quickstart — first feature in 5 minutes
6. Feature Catalog — table of all 17 specs with status
7. Workflow — spec → plan → tasks → implement cycle
8. IPD Gate Reference — TR0-TR6 overview
9. Contributing — how to add new features
10. Versioning — vipd vs speckit version policy
11. License

### Feature Catalog Table
| # | Feature | Status |
|---|---------|--------|
| 001 | IPD Toolkit | ✅ |
| ... | ... | ... |
| 017 | Versioning & Docs | 🚧 |

## Summary of Decisions

| Area | Decision |
|------|----------|
| Version file format | YAML (`.vipd/version.yml`) |
| Display format | `vipd X.Y.Z (speckit A.B.C)` |
| CHANGELOG format | Keep a Changelog |
| Initial versions | vipd 1.0.0, speckit 0.9.3.dev0 |
| CLi script | Bash `vipd` wrapper at repo root |
