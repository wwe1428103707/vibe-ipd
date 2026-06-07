# Quickstart: Project Cleanup & Documentation Rebrand

## Implementation Checklist

### Phase 1: Root README Rewrite
- [ ] Rewrite `README.md` with vibe-ipd identity and purpose
- [ ] Add "Key Differentiators from speckit" section (≥5 items)
- [ ] Add Quickstart section with `/vipd-*` workflow
- [ ] Add Acknowledgments section crediting speckit upstream

### Phase 2: docs/ Rebranding
- [ ] Scan all `.md` files under `docs/` for `speckit` references
- [ ] Replace `speckit` → `vibe-ipd` (project name context)
- [ ] Replace `/speckit-` → `/vipd-` (command references)
- [ ] Update `toc.yml` navigation labels
- [ ] Update `index.md` landing page

### Phase 3: Configuration & Skills
- [ ] Review `.specify/` configs for user-facing branding strings
- [ ] Review `.claude/skills/vipd-*` descriptions for consistency
- [ ] Update `CLAUDE.md` SPECKIT section to 012 plan reference

### Validation
- [ ] Run: `grep -r "speckit" docs/ --include="*.md" -i -c` — verify ≤2 (attribution only)
- [ ] Run: `grep -r "/speckit-" docs/ --include="*.md" -c` — verify 0
- [ ] Run: `grep "speckit" README.md -i -c` — verify 0 outside attribution
