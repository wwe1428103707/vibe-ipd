# Research: PDT Role Mapping & Agent Setup

## Role Definitions (from PDT Setup Guide)

| IPD Role | Agile/SAFe Equivalent | Core Responsibility |
|----------|----------------------|-------------------|
| LPDT (PDT Manager) | Release Train Engineer (RTE) | Cross-team coordination, gate facilitation, impediment removal |
| Product Manager | Product Owner (PO) | Backlog prioritization, user stories, acceptance criteria |
| Development Lead | System Architect / Tech Lead | Architecture decisions, technical standards, CBB management |
| Test Lead | QA Lead | Test strategy, DoD definition, quality metrics |
| Operations Lead | DevOps Lead | CI/CD pipeline, deployment automation, incident response |

## Small-Team Role Combinations

| Team Size | Recommended Combination |
|-----------|------------------------|
| 3 people | LPDT+PO (1), Dev+Ops (1), QA+UX (1) |
| 4 people | LPDT (1), PO+UX (1), Dev+Arch (1), QA+Ops (1) |
| 5 people | Full PDT with shared UX resource |

## Existing Agent Skill Patterns

Current `vipd-agent-assign-*` skills follow this structure:
- **Directory**: `.claude/skills/vipd-agent-assign-<function>/SKILL.md`
- **Frontmatter**: `name:`, `description:`, `user-invocable: true`
- **Body**: Pre-Execution Checks → Outline → Completion Report → Done When

Decision: Role-specific `vipd-agent-assign-*` skills will follow a different (simpler) pattern — they are **persona configurations**, not workflow executors. They define the role's perspective, decision authority, and response constraints. They are designed to be loaded alongside a primary command skill (e.g., `/vipd-agent-assign-lpdt` is invoked when you want an LPDT-framed gate review).

## Skill File Pattern for Role Agents

Each role skill will contain:
1. **Frontmatter** — role name, description, metadata
2. **Role Definition** — the IPD role name, Agile equivalent, core responsibilities
3. **Decision Authority** — what this role can decide vs. recommend vs. escalate
4. **Response Framing** — how the agent should frame its analysis (e.g., "As LPDT, I assess gate readiness based on...")
5. **Constitution Cross-Reference** — which constitutional principles this role primarily enforces

## Claude Code Subagent Integration

Role skills are invoked via:
- Direct invocation: `/vipd-agent-assign-lpdt` (user types this command)
- Subagent spawning: `Agent` tool with role-specific prompt and skill instructions
- Combined invocation: `/vipd-agent-assign-lpdt-po` for small-team combined roles

## Key Design Decisions

1. **SKILL.md over AGENTS.md**: Role definitions live as skills (not agent definitions) because they represent configurable personas that layer on top of the base agent, not independent agent instances.
2. **Explicit authority scope**: Each skill defines what the role can *decide* vs. *recommend* vs. *escalate*, preventing role confusion during gate reviews.
3. **Combined roles for small teams**: Pre-defined combined skills (LPDT+PO, DevOps+QA) avoid the need for runtime role stitching.
