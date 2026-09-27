# EaaSGrid EaaS UAT Plan and Initial Evidence

Version: 0.1 | Status: BASELINE

## UAT objective

Validate that the EaaS product meets approved business and functional requirements
before each production release. UAT is evidence-based and traceable to BRD requirements.

## Initial UAT cases

| ID | Requirement | Test | Status |
|---|---|---|---|
| UAT-001 | Public website available | Open HTTPS URL | PASS |
| UAT-002 | Correct EaaS identity | Verify title, content and contact | PASS |
| UAT-003 | Energy enquiry | Validate assessment form and mail route | REVIEW |
| UAT-004 | National geography | Verify states/FCT representation | PASS |
| UAT-005 | Human-centred visual experience | Verify people/field imagery | PASS |
| UAT-006 | Mobile responsive layout | Test common viewport sizes | PENDING |
| UAT-007 | Documentation availability | Verify documentation register | PASS |
| UAT-008 | Internal identity/RBAC | Authenticate using XaaSGrid identity | PENDING |
| UAT-009 | CRM lead creation | Create and trace EaaS lead | PENDING |
| UAT-010 | Energy assessment workflow | Discovery to assessment | PENDING |

## Acceptance gates

- All critical UAT cases PASS.
- No open release-blocking defects.
- Evidence is captured for every approved requirement.
- BRD and functional documentation reflect the released behaviour.
- Deployment and rollback procedures are documented.
- Backup/recovery evidence exists for production data.
