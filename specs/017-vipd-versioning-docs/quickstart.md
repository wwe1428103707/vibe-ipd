# Quickstart: VIPD Versioning & Docs Preparation

**Date**: 2026-06-08 | **Plan**: [plan.md](plan.md) | **Spec**: [spec.md](spec.md)

## Implementation Steps

### Step 1: Create `.vipd/version.yml`

```yaml
# .vipd/version.yml — Single source of truth for versions
vipd_version: "1.0.0"
speckit_version: "0.9.3.dev0"
```

Validate against `contracts/version-schema.json`.

---

### Step 2: Create `vipd` CLI Wrapper

Create `vipd` (executable bash script) at repo root:

```bash
#!/usr/bin/env bash
# vipd — VIPD CLI wrapper
# Usage: vipd --version, vipd --help

VIPD_DIR="$(cd "$(dirname "$0")/.vipd" && pwd 2>/dev/null)"

if [ "$1" = "--version" ] || [ "$1" = "-v" ]; then
  if [ -f "$VIPD_DIR/version.yml" ]; then
    VIPD_VER=$(grep '^vipd_version:' "$VIPD_DIR/version.yml" | awk '{print $2}' | tr -d '"')
    SPECKIT_VER=$(grep '^speckit_version:' "$VIPD_DIR/version.yml" | awk '{print $2}' | tr -d '"')
    echo "vipd ${VIPD_VER:-unknown} (speckit ${SPECKIT_VER:-unknown})"
  else
    echo "vipd unknown (speckit unknown)"
  fi
  exit 0
fi

if [ "$1" = "--help" ] || [ "$1" = "-h" ] || [ $# -eq 0 ]; then
  echo "vipd — Vibe IPD Toolkit"
  echo ""
  echo "Usage:"
  echo "  vipd --version     Show version information"
  echo "  vipd --help        Show this help message"
  echo ""
  echo "Commands (via Claude Code slash commands):"
  echo "  /vipd-specify      Create a feature specification"
  echo "  /vipd-plan         Create an implementation plan"
  echo "  /vipd-tasks        Generate task list"
  echo "  /vipd-implement    Execute tasks"
  echo "  /vipd-init         Initialize a new project"
  echo ""
  echo "See README.md for full documentation."
  exit 0
fi

echo "Unknown option: $1"
echo "Usage: vipd --version or vipd --help"
exit 1
```

Make executable: `chmod +x vipd`

---

### Step 3: Create `CHANGELOG.md`

```markdown
# Changelog

## [1.0.0] - 2026-06-08

### Added

- Complete IPD (Integrated Product Development) toolkit for Claude Code
- Spec-first workflow with spec → plan → tasks → implement cycle
- IPD gate validation (TR0-TR6) with automated checks
  - 001: IPD Toolkit — Core gate framework and constitution
  - 002-010: Agent integration, docstate, command prefix, gate implementation
- Multilingual support
  - 011: Multilingual greeting (hello.sh --lang en/zh/ja)
  - 014: Chinese documentation translation (docs/zh/)
  - 016: VIPD Init language option (--lang flag, .vipd/config.yml)
- Project initialization
  - 013: vipd-init skill (uvx/pipx-based scaffolding)
  - 017: Version management and release preparation
- Meta workflow improvements
  - 012: Project cleanup and documentation rebrand
  - 015: Fix TR gate chicken-egg dependency

[1.0.0]: https://github.com/wwe1428103707/vibe-ipd/releases/tag/v1.0.0
```

---

### Step 4: Create `VERSION_BUMP.md`

```markdown
# Version Bump Process

VIPD follows semantic versioning (MAJOR.MINOR.PATCH), same conventions as speckit.

## When to Bump

| Bump | When | Example |
|------|------|---------|
| MAJOR | Breaking workflow changes, backward-incompatible format changes | 1.0.0 → 2.0.0 |
| MINOR | New features implemented (new specs) | 1.0.0 → 1.1.0 |
| PATCH | Bug fixes, doc updates, refactoring | 1.0.0 → 1.0.1 |

## Process

1. Update `.vipd/version.yml`
2. Add entry to `CHANGELOG.md`
3. Commit with message: `chore: bump version to X.Y.Z`
4. Tag the release: `git tag vX.Y.Z`
5. Push: `git push origin main --tags`

Note: Only `vipd_version` is bumped. `speckit_version` changes only when the project updates its speckit dependency.
```

---

### Step 5: Update `README.md`

Update README.md with:
1. Project title + vipd version badge
2. Description section explaining vipd as an IPD toolkit
3. Prerequisites (uv/pipx, git, Claude Code)
4. Quick install instructions
5. Quickstart: first feature in 5 minutes
6. Feature catalog table (all 17 features with status)
7. Workflow diagram: spec → plan → tasks → implement
8. IPD gate reference (TR0-TR6)
9. Versioning policy
10. License

### Step 6: Update `README.zh.md`

Chinese translation of the updated README, matching all sections.

---

## Verification Checklist

- [ ] `vipd --version` outputs `vipd 1.0.0 (speckit 0.9.3.dev0)`
- [ ] `vipd --help` shows usage message
- [ ] `.vipd/version.yml` validates against `version-schema.json`
- [ ] `CHANGELOG.md` lists all 17 features
- [ ] `VERSION_BUMP.md` documents bump process
- [ ] `README.md` covers all required sections
- [ ] `README.zh.md` matches `README.md` content
