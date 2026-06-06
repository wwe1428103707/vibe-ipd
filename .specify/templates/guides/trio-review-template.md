---
description: "Structured Product Trio review template for feature discovery validation"
---

# Product Trio Review: [FEATURE NAME]

**Date**: [YYYY-MM-DD]
**Review Type**: TR1 Concept Gate / Pre-Delivery Backlog

## Feature Summary

**Feature**: [brief name]
**Spec**: [link to spec.md]
**Brief**: [1-2 sentence problem statement]

---

## PO Assessment

**Reviewer**: PO / Product Manager

**Authority**: PO decides on feature validity

### Business Value
- Market need: [description]
- Business impact: [H / M / L]
- User segment: [target users]
- WSJF score: [Value + Criticality + Risk / Size]

### Acceptance Criteria
- [ ] Clear, testable criteria defined
- [ ] Success criteria measurable
- [ ] Scope clearly bounded

### PO Verdict
- **Go** / **No-Go** / **Recycle**
- Rationale: [why]
- Priority: [P1 / P2 / P3 / P4]

---

## Architect Assessment

**Reviewer**: System Architect / Tech Lead

**Authority**: Architect decides on technical feasibility

### Technical Assessment
- Approach: [description]
- CBB reuse: [opportunities]
- New dependencies: [list]
- Effort estimate: [XS / S / M / L / XL]

### Compliance Check
- [ ] Architecture patterns followed
- [ ] No unnecessary new technology
- [ ] Scalability requirements addressed
- [ ] Security implications considered

### Architect Verdict
- **Feasible** / **Feasible with changes** / **Not feasible**
- Recommendations: [specific guidance]
- Risk level: [H / M / L]

---

## UX Assessment

**Reviewer**: UX Designer

**Authority**: Recommends on user experience quality

### UX Assessment
- Workflow clarity: [Clear / Needs work / Unclear]
- Edge cases covered: [Yes / Partial / No]
- Accessibility: [Considered / Not considered / N/A]

### UX Verdict
- **OK** / **Needs revision** / **Blocking**
- Notes: [specific concerns or recommendations]

---

## Consolidated Decision

| Role | Verdict | Notes |
|------|---------|-------|
| PO | Go / No-Go / Recycle | |
| Architect | Go / No-Go / Recycle | |
| UX | Go / No-Go / Recycle | |

### Final Decision
- **Go** → Cleared for delivery backlog
- **No-Go** → Blocked: [reason]
- **Recycle** → Return for refinement: [what needs clarification]

**Escalation needed**: Yes / No
**Escalation target**: LPDT / Architecture Board / IPMT

---

## Evidence & Artifacts

- [ ] Feature spec: [link]
- [ ] Feasibility assessment: [link]
- [ ] UX prototype/wireframe: [link]
- [ ] Risk assessment: [link]
