# Quickstart: Using the IPD Transformation Plan Documents

**Branch**: `001-ipd-toolkit` | **Date**: 2026-06-06

## What These Documents Are

This collection of 4 plan documents provides a comprehensive blueprint for
transforming the Spec Kit SDD toolkit into an IPD-enhanced toolkit. They are
**descriptive guidance documents** — they tell you WHAT to do and WHY, but
leave the HOW (actual implementation) to subsequent feature cycles.

## Recommended Reading Order

### 1. Start with the Roadmap
**File**: `01-transformation-roadmap.md`

Understand the full scope, phases, and timeline. The roadmap gives you the
"big picture" — what needs to happen, in what order, and how the phases
depend on each other.

**Time**: ~30 minutes to read and understand.

### 2. Dive into the Redesign Guide
**File**: `02-command-template-redesign-guide.md`

This is the most detailed technical document. It tells you exactly how each
SDD command and template needs to change to support IPD gates.

**Who should read**: AI coding agent maintainers, skill developers.

### 3. Configure Tooling
**File**: `03-tooling-integration-blueprint.md**

Once you understand the process changes, configure the project management
platform to enforce them.

**Who should read**: Platform engineers, DevOps leads.

### 4. Set Up Your Team
**File**: `04-role-mapping-pdt-setup-guide.md`

Structure your team according to IPD role mappings before launching the
first IPD-enhanced project.

**Who should read**: PDT managers, team leads.

## How to Use These Documents in the SDD Workflow

```text
1. Read 01-roadmap → Understand full scope
2. Read 04-roles → Set up your PDT structure
3. Read 02-redesign → Plan command/template updates
4. Implement command updates (separate feature cycle)
5. Read 03-blueprint → Configure tooling
6. Implement tooling config (separate feature cycle)
7. Launch first IPD-enhanced project
```

## Prerequisites

- Understanding of SDD fundamentals (Spec Kit README)
- Familiarity with the IPD fusion guide
- Access to a project management platform with Advanced Roadmaps (Jira Cloud
  Premium or equivalent recommended)

## Next Steps After Reading

1. **Create feature specs** for implementing each phase of the roadmap
2. **Implement command changes** using the Redesign Guide as requirements
3. **Configure tooling** per the Blueprint
4. **Train the team** per the Role Mapping Guide
5. **Pilot** a single IPD-enhanced feature cycle

## Cross-Reference

See the [data-model.md](data-model.md) for the full entity relationship map
between all 4 documents.
