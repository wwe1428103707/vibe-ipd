> **[English](.)** · [中文](../zh/concepts/sdd.md)

# What is Spec-Driven Development?

Spec-Driven Development **flips the script** on traditional software development. For decades, code has been king — specifications were just scaffolding we built and discarded once the "real work" of coding began. Spec-Driven Development changes this: **specifications become executable**, directly generating working implementations rather than just guiding them.

## Core Philosophy

Spec-Driven Development is a structured process that emphasizes:

- **Intent-driven development** where specifications define the "*what*" before the "*how*"
- **Rich specification creation** using guardrails and organizational principles
- **Multi-step refinement** rather than one-shot code generation from prompts
- **Heavy reliance** on advanced AI model capabilities for specification interpretation

## Development Phases

| Phase | Focus | Key Activities |
|-------|-------|----------------|
| **0-to-1 Development** ("Greenfield") | Generate from scratch | <ul><li>Start with high-level requirements</li><li>Generate specifications</li><li>Plan implementation steps</li><li>Build production-ready applications</li></ul> |
| **Creative Exploration** | Parallel implementations | <ul><li>Explore diverse solutions</li><li>Support multiple technology stacks & architectures</li><li>Experiment with UX patterns</li></ul> |
| **Iterative Enhancement** ("Brownfield") | Brownfield modernization | <ul><li>Add features iteratively</li><li>Modernize legacy systems</li><li>Adapt processes</li></ul> |

## Experimental Goals

Our research and experimentation focus on:

### Technology Independence

- Create applications using diverse technology stacks
- Validate the hypothesis that Spec-Driven Development is a process not tied to specific technologies, programming languages, or frameworks

### Enterprise Constraints

- Demonstrate mission-critical application development
- Incorporate organizational constraints (cloud providers, tech stacks, engineering practices)
- Support enterprise design systems and compliance requirements

### User-Centric Development

- Build applications for different user cohorts and preferences
- Support various development approaches (from vibe-coding to AI-native development)

### Creative & Iterative Processes

- Validate the concept of parallel implementation exploration
- Provide robust iterative feature development workflows
- Extend processes to handle upgrades and modernization tasks

---

# What is Integrated Product Development (IPD)?

Integrated Product Development (IPD) is a product-centric comprehensive development management framework, pioneered by Huawei's adoption of IBM's IPD practices. IPD treats product development as a **capital investment**, using staged gate reviews (TR0–TR6) to manage technical risk and ensure end-to-end control from concept to delivery.

## Core Principles

| Principle | Description |
|-----------|-------------|
| **Development as Investment** | Every feature/project requires business justification with explicit Go/Kill decision points |
| **Market-Based Innovation** | Requirements originate from market analysis rather than technology push, ensuring you build the right thing |
| **Cross-Functional Collaboration** | PDT (Product Development Team) includes market, development, test, and operations roles, breaking down silos |
| **Concurrent Development** | Discovery track runs in parallel with delivery track, reducing time-to-market |
| **Structured Process** | Clear phase definitions, gate criteria, and role assignments reduce uncertainty |

## IPD Stage-Gate Model (TR0–TR6)

vibe-ipd implements the complete Technology Review (TR) gate model:

| Gate | Phase | Review Focus |
|------|-------|--------------|
| **TR0** | Concept Initiation | Feasibility assessment, business case readiness |
| **TR1** | Specification Review | Specification completeness, user story clarity |
| **TR2** | Plan Review | Implementation plan completeness, architecture viability |
| **TR3** | Design Review | Detailed design quality, interface contract definition |
| **TR4** | Implementation Verification | Code implementation completeness, test coverage |
| **TR5** | System Validation | Integration testing, performance/security assessment |
| **TR6** | Release Decision | Release readiness check, Go/Kill/Hold/Recycle decision |

Each `/vipd-*` command performs deep content validation against prior gate criteria before proceeding, ensuring no quality gates are skipped.

## PDT Role Mapping with RACI Matrix

IPD emphasizes cross-functional team collaboration. vibe-ipd maps IPD roles to agile team roles:

| IPD Role | Agile Role Mapping | Key Responsibilities |
|----------|-------------------|---------------------|
| LPDT (Product Development Team Leader) | RTE (Release Train Engineer) | Process management, gate facilitation |
| Product Manager | PO (Product Owner) | Requirements definition, value prioritization |
| Dev Lead | System Architect | Technical solutions, architecture decisions |
| Test Lead | QA Lead | Quality assurance, test strategy |
| Ops Lead | DevOps Lead | Deployment, operations, environment management |

## Product Trio

The core of the IPD discovery track is the **Product Trio**:

- **Product Manager (PO)** — defines the "*what*", focused on user value and business goals
- **System Architect** — defines the "*how*", focused on technical solutions and system quality
- **UX Designer** — defines the "*looks like*", focused on user experience and interaction design

All three roles collaborate in parallel, completing requirements clarification, technical assessment, and design validation before iteration begins, reducing rework in the delivery track.

---

# What is the Agile-Stage-Gate Hybrid Model?

The Agile-Stage-Gate Hybrid combines **agile's flexible iteration** with **stage-gate's rigorous governance** — the core operating model of vibe-ipd.

## Why a Hybrid Model?

| Pure Agile | Pure Stage-Gate | Hybrid (vibe-ipd) |
|------------|-----------------|-------------------|
| Lacks high-level governance, prone to goal drift | Rigid process, slow to respond to change | Flexible iteration + stage gatekeeping |
| Gate decisions rely on manual review meetings | Gates become administrative overhead | AI-powered deep content validation, reducing burden |
| Large projects can easily go off track | Unsuitable for rapid prototyping | Discovery track (agile) + Delivery track (gate) |

## Dual-Track Operating Model

```
Timeline →
──────────────────────────────────────────────────
Discovery Track (Agile) ── Product Trio continuous exploration
  │  ┌──────┐  ┌──────┐  ┌──────┐
  │  │ Sprint 1 │  │ Sprint 2 │  │ Sprint 3 │  ...
  │  └──────┘  └──────┘  └──────┘
  │       │           │           │
Delivery Track (Gate) ── Gate-validated implementation
  │       ▼           ▼           ▼
  │  ┌─ TR0 ─┐  ┌─ TR2 ─┐  ┌─ TR4 ─┐
  │  │Concept │  │ Plan   │  │Implement│
  │  └───────┘  └───────┘  └───────┘
```

- **Discovery Track**: Uses agile Scrum/Kanban, with the Product Trio continuously exploring requirements and validating assumptions
- **Delivery Track**: Uses stage-gates as milestones; each TR gate automatically validates preconditions to ensure quality checkpoints
- **Parallel Tracks**: Discovery track output feeds directly into the next gate phase of the delivery track, reducing wait time

## Gate Decision Mechanism

Each TR gate review produces one of four decisions:

| Decision | Meaning | Follow-up Action |
|----------|---------|------------------|
| **Go** | Pass | Proceed to next phase |
| **Kill** | Terminate | Stop feature/project development |
| **Hold** | Pause | Suspend work, wait for conditions to mature |
| **Recycle** | Rework | Return to previous phase, fix issues, re-review |

## AI-Enhanced Gate Enforcement

Traditional stage-gate relies on manual review and document audits, which is inefficient. vibe-ipd leverages AI agents to achieve:

- **Deep Content Validation** — not just checking document existence, but understanding whether content meets gate criteria
- **Automatic Quality Gates** — each `/vipd-*` command auto-validates prior gates without manual review initiation
- **Agent Orchestration** — 50+ specialized agent roles collaborate covering architecture, security, testing, and more
- **ADL (Architecture Decision Log)** — automatically records key technical decisions and their rationale, supporting traceability and audit
