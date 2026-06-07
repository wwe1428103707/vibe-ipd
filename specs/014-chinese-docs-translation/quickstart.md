# Translation Process Guide

**Plan**: [plan.md](plan.md) | **Date**: 2026-06-07

## Purpose

This guide provides the step-by-step process for creating Chinese translations of vibe-ipd documentation. Follow this when implementing the translation tasks.

## Prerequisites

- English source document identified in [data-model.md](data-model.md)
- [Translation glossary](../research.md#translation-glossary) for consistent terminology
- [Link mapping contract](contracts/link-mapping.md) for toggle links and cross-references

## Translation Workflow

### Step 1: Select document by priority

Start with P1 documents (quickstart, installation), then P2 (reference), then P3 (concepts). Refer to [data-model.md](data-model.md) for the full priority-ordered catalog.

### Step 2: Create Chinese document under `docs/zh/`

```text
English:  docs/quickstart.md
Chinese:  docs/zh/quickstart.md
```

Create the directory structure if needed:
```bash
mkdir -p docs/zh/concepts
mkdir -p docs/zh/reference
```

### Step 3: Add language toggle

Insert at the top of the Chinese document:
```markdown
> [English](../<path-to-english>) · **[中文](.)**
```

### Step 4: Translate prose, preserve code

- Translate all prose text using the [glossary](../research.md#translation-glossary)
- Preserve all fenced code blocks (```) verbatim
- Preserve all inline code (`code`) verbatim
- Preserve all headings structure (same H1/H2/H3 hierarchy)
- Preserve all lists, tables, and blockquotes structure

### Step 5: Adjust relative links

Use the [link-mapping contract](contracts/link-mapping.md) to:
- Rewrite links to other docs → point to `docs/zh/` equivalents
- Keep external links (https://...) unchanged
- Keep anchor links (#section) with translated anchor text

### Step 6: Add language toggle to English source (optional)

If not already present, add to the English source:
```markdown
> **[English](.)** · [中文](<path-to-chinese>)
```

### Step 7: Verify translation quality

Check against these criteria:
- [ ] All headings from English original exist in Chinese (same count)
- [ ] Code blocks match English original exactly (diff non-prose content)
- [ ] Language toggle links work (bidirectional)
- [ ] All relative links resolve correctly
- [ ] Glossary terms use the established Chinese translations
- [ ] Technical terms are accurate within context

## Document ordering

Recommended translation order (by priority and dependency):

1. `docs/zh/quickstart.md` (P1 — most visible, independent)
2. `docs/zh/installation.md` (P1 — independent)
3. Update `README.zh.md` links (P1 — can point to completed translations)
4. `docs/zh/reference/*.md` (P2 — all independent of each other)
5. `docs/zh/concepts/sdd.md` (P3 — supplementary)
6. Optional: `docs/zh/index.md`, `docs/zh/upgrade.md`, etc.

## Translation verification checklist

After translating each document, run this check:

```bash
# Compare heading count
grep -c "^##" docs/quickstart.md
grep -c "^##" docs/zh/quickstart.md

# Extract and compare code blocks (manual visual check)
# Ensure code blocks are identical between English and Chinese versions

# Check language toggle exists
head -3 docs/zh/quickstart.md | grep -E "\[English\]|\[中文\]"
```
