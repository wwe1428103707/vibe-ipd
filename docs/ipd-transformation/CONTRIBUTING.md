# Document Formatting Conventions

**Part of**: IPD Toolkit Transformation Plan Collection

## Heading Hierarchy

- `#` — Document title (only one per file)
- `##` — Major sections
- `###` — Subsections
- `####` — Sub-subsections (use sparingly)

## Cross-Reference Syntax

Reference other documents in this collection using relative Markdown links:

```markdown
See [Transformation Roadmap](01-transformation-roadmap.md) for phasing details.
```

Reference the IPD fusion guide using a relative path from the docs root:

```markdown
See the IPD fusion guide [Section §3.2](../IPD与敏捷开发深度融合的软件产品开发流程与研发管理平台搭建指南.md).
```

Reference constitutional principles by number:

```markdown
This aligns with **Principle III (Agile-Stage-Gate Governance)**.
```

## Terminology Rules

- Always use the canonical term from the [glossary](glossary.md) on first
  reference in each document.
- Provide the English term in parentheses on first use, e.g.,
  "技术评审 (Technology Review, TR)".
- Use the abbreviation thereafter, e.g., "TR1 gate".
- Keep abbreviations consistent across all 4 documents.

## Metadata Frontmatter

Each document SHOULD start with a brief metadata block:

```markdown
**Document**: IPD Transformation Roadmap
**Part of**: IPD Toolkit Transformation Plan Collection
**Status**: Draft
**Date**: 2026-06-06
```

## Tables

- Use GFM table syntax with alignment markers.
- Keep tables readable: no more than 6–8 columns.
- Use `—` for empty cells rather than leaving them blank.

## Code Blocks

Code blocks (fenced with ```) are used ONLY for:
- Structural examples (e.g., directory trees, JSON structures)
- Illustrative configuration patterns (descriptive, not executable)

No executable code, scripts, or commands should appear per the "purely
descriptive" scope constraint.

## File Naming

- All files use lowercase with hyphens: `01-transformation-roadmap.md`
- Numeric prefix indicates reading order (01 → 04)
- Glossary and contributing guide have no numeric prefix
