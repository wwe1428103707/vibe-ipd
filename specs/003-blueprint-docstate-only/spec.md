# Feature Specification: Blueprint Document-State Only

**Feature Branch**: `003-blueprint-docstate-only`

**Created**: 2026-06-06

**Status**: Draft

**Input**: User description: "03-tooling-integration-blueprint 直接去掉对于JIRA等内容，只保留文档状态模式。"

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Blueprint Simplified to Document-State Mode (Priority: P1)

As a project maintainer reading the Tooling Integration Blueprint, I need
the document to focus exclusively on Spec Kit's native document-state mode
for IPD gate enforcement, removing all Jira-specific content, so that the
blueprint is concise, immediately actionable, and doesn't require external
tooling to implement.

**Why this priority**: The previous blueprint contained extensive Jira
configuration guidance (issue hierarchy, Advanced Roadmaps, automation rules,
CI/CD webhooks) that is irrelevant for teams using Spec Kit's native agent
gate enforcement. Stripping this content makes the document 60-70% shorter
and directly useful.

**Independent Test**: A reader can understand how to set up IPD gate
enforcement entirely from reading the simplified blueprint, without needing
Jira or any external platform.

**Acceptance Scenarios**:

1. **Given** the current blueprint at `docs/ipd-transformation/03-tooling-integration-blueprint.md`,
   **When** the rewrite is complete, **Then** it MUST NOT contain any
   Jira-specific sections (issue hierarchy configuration, Advanced Roadmaps,
   Jira automation rules, Jira webhook configurations).
2. **Given** the rewritten blueprint, **When** a maintainer reads it,
   **Then** the ONLY gate enforcement mechanism described MUST be the Spec Kit
   Agent Integration (Document-State Mode).
3. **Given** the rewritten blueprint, **When** compared to the original,
   **Then** the document MUST be at least 50% shorter.

---

### User Story 2 - Chinese Blueprint Parallel Update (Priority: P1)

As a Chinese-speaking reader, I need the Chinese blueprint
(`zh/03-工具集成蓝图.md`) to be updated in parallel with the English version,
removing all Jira content and keeping only the document-state mode.

**Why this priority**: The English and Chinese versions must remain in sync
(per FR-011 from the previous feature). Leaving one outdated would create
confusion.

**Independent Test**: The Chinese blueprint contains no Jira references and
matches the structure of the simplified English version.

**Acceptance Scenarios**:

1. **Given** the Chinese blueprint at `docs/ipd-transformation/zh/03-工具集成蓝图.md`,
   **When** the rewrite is done, **Then** it MUST NOT contain any
   Jira-specific content.
2. **Given** the Chinese blueprint, **When** compared to the English version,
   **Then** both documents MUST have the same section structure.

---

### User Story 3 - Cross-Reference Cleanup (Priority: P2)

As a maintainer of the IPD transformation document collection, I need all
cross-references that previously pointed to Jira-specific sections of the
blueprint to be removed or updated, so that the document collection remains
consistent.

**Why this priority**: Inconsistent cross-references would confuse readers
and reduce trust in the documentation.

**Independent Test**: A grep for "Advanced Roadmaps", "Jira", or "Jira Cloud"
across all documents in `docs/ipd-transformation/` returns zero matches
(except in the history/glossary).

**Acceptance Scenarios**:

1. **Given** all documents in `docs/ipd-transformation/`, **When** searched
   for external tooling references, **Then** `03-tooling-integration-blueprint.md`
   and `zh/03-工具集成蓝图.md` MUST contain zero references to Jira, Advanced
   Roadmaps, or any external platform configuration.
2. **Given** the redesign guides (`02-*`), **When** checking cross-references,
   **Then** references to the blueprint's Jira sections MUST be removed.

### Edge Cases

- What if a team was already using the Jira configuration from the original
  blueprint? (Assumption: Jira content is being removed from the blueprint
  document, but the 002-ipd-agent-pm-integration feature already established
  that document-state mode is the primary approach; Jira can still be
  referenced in the Platform Alternatives section if kept minimal.)
- What if the blueprint needs to reference external tooling in the future?
  (Keep a minimal "Platform Alternatives" section as a placeholder, but
  remove all configuration guidance.)

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The English blueprint MUST be rewritten to remove all Jira-specific
  sections: Issue Hierarchy Configuration, Workflow States & TR Gate Transitions,
  Automation Rules, Advanced Roadmaps Dependency Management, and CI/CD Integration.
- **FR-002**: The ONLY gate enforcement mechanism described in the blueprint
  MUST be the "Spec Kit Agent Integration (Document-State Mode)" section.
- **FR-003**: The blueprint MUST retain a minimal "Platform Alternatives"
  section (2-3 sentences + a simplified comparison table) as a reference,
  without configuration step-by-step guidance.
- **FR-004**: The Overview section MUST be rewritten to focus on document-state
  mode as the primary approach, removing the Jira-centric introduction.
- **FR-005**: The Chinese blueprint `zh/03-工具集成蓝图.md` MUST be updated
  in parallel with identical structural changes.
- **FR-006**: All cross-references from `docs/ipd-transformation/02-command-template-redesign-guide.md`
  and `zh/02-命令与模板改造指南.md` that reference blueprint Jira sections
  MUST be updated or removed.
- **FR-007**: The Cross-References section at the end of the blueprint MUST
  be preserved, linking to the Transformation Roadmap and Redesign Guide.

### Key Entities

- **Simplified Blueprint (English)**: `docs/ipd-transformation/03-tooling-integration-blueprint.md`
  after removing all Jira content.
- **Simplified Blueprint (Chinese)**: `docs/ipd-transformation/zh/03-工具集成蓝图.md`
  updated in parallel.
- **Redesign Guide Cross-References**: References in `02-command-template-redesign-guide.md`
  and its Chinese counterpart pointing to blueprint Jira sections.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: The simplified English blueprint is at most 40% of its original
  length (was ~220 lines, should be ≤90 lines).
- **SC-002**: A reader can understand the complete gate enforcement setup from
  reading the simplified blueprint alone, without referencing external platform
  documentation.
- **SC-003**: Zero Jira/external tooling references remain in either blueprint
  document (English or Chinese).
- **SC-004**: The Chinese and English blueprints have identical section
  structure (same headings, same order).

## Assumptions

- The "Spec Kit Agent Integration (Document-State Mode)" section added in
  the 002 feature forms the core of the new simplified blueprint.
- Teams that previously used the Jira configuration guidance can still access
  it via git history — removal from the document doesn't lose the information.
- The blueprint documents are the only files being substantially rewritten —
  other documents in the collection only need cross-reference updates.
- The existing glossary already covers IPD/Agile terms — no new glossary
  entries needed for the simplified document.
- The Chinese translation follows the same structural changes as the English
  version, maintaining the terminology convention from the existing glossary.
