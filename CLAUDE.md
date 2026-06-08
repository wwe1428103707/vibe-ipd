<!-- SPECKIT START -->
For additional context about the current implementation plan,
read the plan at `specs/016-vipd-init-language/plan.md`.
Design artifacts (research, data-model, contracts, quickstart) are in the same directory.
Feature: VIPD Init Language Option — implemented. `vipd init --lang zh` selects Chinese, language persisted in `.vipd/config.yml`, overridable per-command. Language resources in `lang/en.yml` and `lang/zh.yml` with `t()` fallback lookup. Config is the default; `--lang` flag overrides without modifying config.
Gate status: TR4/TR4A implementation complete ✅ (+28 tasks across 7 phases)
Next: /vipd-git-commit to commit changes or /vipd-analyze for cross-artifact review
<!-- SPECKIT END -->
