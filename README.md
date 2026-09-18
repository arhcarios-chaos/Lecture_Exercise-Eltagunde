# Preliminary System Proposal: UniServe

## Part I - Systems Analysis and Design

### 1. Understanding the existing system

| Area | Response |
| --- | --- |
| Existing system | Paper forms, email, and social-media messages handled separately by offices. |
| Major problem | Requests lack a central record, clear ownership, and visible status. |
| People affected | Students, service-office staff, office heads, and university management. |
| Current processes | Student finds an office, submits a form/message, staff records it locally, processes it, and answers follow-ups manually. |
| Information/data | Student identity, request type, documents, dates, staff action, and status - spread across paper and spreadsheets. |
| Proposed system | Web-based Student Service Request and Tracking System backed by Supabase. |
| Expected benefits | One intake point, traceability, faster status communication, measurable workload, and accountability. |

### 2. Problem and opportunity analysis

| Problem | Possible cause | Effect | System opportunity |
| --- | --- | --- | --- |
| Requests are lost or overlooked | Paper/email records are decentralized | Delays and student dissatisfaction | Centralized database with reference numbers and queue |
| Students repeatedly ask for updates | No self-service status view | Staff time diverted from processing | Student dashboard and status timeline |
| Offices have inconsistent records | Separate spreadsheets and forms | Duplicate work and unreliable reporting | Shared request record with role-based access |
| Processing is hard to monitor | No timestamps, assignment, or priority standard | Backlogs and weak accountability | Time-stamped updates, staff assignment, priorities, and reports |

### 3. Stakeholders

| Stakeholder | Role / information needed | Involvement |
| --- | --- | --- |
| Students | Submit requests, reference number, status, completion notice | High |
| Service-office staff | Queue, supporting documents, priority, update history | High |
| Office heads | Workload, overdue items, turnaround performance | High |
| University administrators | Cross-unit counts, trends, service performance | Medium |
| IT / system administrator | Accounts, security, backups, technical support | High |

Understanding the existing process prevents automation of a flawed workflow. It identifies the real information gaps, exceptions, business rules, and affected people before time and budget are committed.

## Part II - Project management

### 4. Objective

The project aims to develop a web-based Student Service Request and Tracking System that will enable students, service-office personnel, and administrators to submit, process, and monitor service requests by centralizing records, status updates, and performance reporting.

### 5. Scope

**In scope:** student registration/sign-in; online request submission; service type and priority; attachment upload; generated reference number; student history/status view; staff queue and assignment; status/timeline updates; administrator dashboard; basic reports; role-based access; Supabase database and storage.

**Out of scope:** integration with the student information system; online payment; automated document generation with digital signatures; native mobile application; AI chatbot; migration of all historical paper records.

### 6. Twelve-week plan

| Activity | Week(s) | Deliverable |
| --- | --- | --- |
| Project initiation | 1 | Charter, team roles, stakeholder list |
| Requirements gathering | 1-2 | Interview, observation, and document findings |
| Requirements analysis | 3 | Approved requirements specification and scope |
| System and UI design | 4-5 | Wireframes, use cases, process design |
| Database design | 4-5 | ERD, Supabase schema, security rules |
| Development | 6-9 | Working student, staff, and admin features |
| Testing | 9-10 | Test cases and defect log |
| User acceptance testing | 11 | Signed UAT feedback and refinements |
| Deployment / presentation | 12 | Production release, guide, presentation |

### 7. Risk analysis

| Risk | Probability | Impact | Response |
| --- | --- | --- | --- |
| Requirements change late | M | H | Baseline scope in week 3; use change log and approval. |
| Key stakeholders unavailable | M | H | Book sessions early; designate alternates; use questionnaires. |
| Sensitive student data exposed | L | H | Use Supabase Auth, RLS, private files, and security testing. |
| Integration expectations exceed scope | M | M | Document exclusions and defer integrations to a later phase. |
| Testing finds major defects | M | H | Start unit/integration testing in week 9 and reserve remediation time. |

If only 50% is complete by week 9, I would (1) re-plan around a minimum viable release: request submission, tracking, staff updates, and security; and (2) freeze new features, assign owners to the critical path, and conduct daily risk/defect review with the sponsor.

## Part III - Requirements analysis

### 8. Requirements-gathering plan

| Technique | Target stakeholder | Information to collect | Why |
| --- | --- | --- | --- |
| Interview | Student Services Office head | Rules, escalations, approval paths, performance measures | Reveals decisions and exceptions. |
| Observation | Frontline service staff | Actual intake, routing, verification, and status-update work | Exposes workarounds not described in interviews. |
| Document analysis | Office heads and IT | Forms, spreadsheets, service catalogs, retention rules | Defines required fields and current data quality. |

### 9. Interview questions

1. What request types do you handle, and what information or documents are required for each?
2. How do you decide which requests are urgent, and who may override the priority?
3. What status steps does a request pass through, including holds, rejection, and completion?
4. Which requests are routed to other offices, and what information must travel with them?
5. Which reports or turnaround-time measures do you need to review each week or month?

### 10. Functional requirements

- FR-01: The system shall allow students to submit a service request online.
- FR-02: The system shall authenticate users and apply student, staff, or administrator permissions.
- FR-03: The system shall generate a unique reference number for each submitted request.
- FR-04: The system shall allow students to view their request history, current status, and update timeline.
- FR-05: The system shall allow students to attach supporting documents to a request.
- FR-06: The system shall allow authorized staff to view, evaluate, assign, prioritize, and update requests.
- FR-07: The system shall record the staff member, timestamp, status, and note for every request update.
- FR-08: The system shall allow administrators to view request volume, completion rate, pending requests, and service-type reports.

### 11. Non-functional requirements

| ID | Category | Specific requirement |
| --- | --- | --- |
| NFR-01 | Security | The system shall require authentication and enforce row-level authorization so students can access only their own requests. |
| NFR-02 | Performance | The system shall display a student’s request history within three seconds under normal operating conditions. |
| NFR-03 | Usability | A student shall be able to submit a standard request in five minutes or less without training. |
| NFR-04 | Reliability | The system shall maintain at least 99% availability during published office hours, excluding scheduled maintenance. |
| NFR-05 | Compatibility/accessibility | The system shall work on current Chrome, Edge, Firefox, and Safari at desktop and mobile widths, with keyboard-accessible controls and labeled inputs. |

## Part IV - Classification challenge

| # | Classification |
| --- | --- |
| 1 | Functional |
| 2 | Non-functional |
| 3 | Functional |
| 4 | Non-functional |
| 5 | Functional |
| 6 | Functional |
| 7 | Non-functional |
| 8 | Functional |
| 9 | Non-functional |
| 10 | Functional |

## Final synthesis

**Problem statement.** Student requests are currently received through paper, email, and social media, with each office maintaining separate records. This causes lost or incomplete requests, unclear routing, repeated follow-up messages, and limited accountability. Management cannot consistently measure workload or processing time. A centralized workflow is needed to make requests visible, traceable, and measurable.

**Target users.** Students; service-office personnel and heads; university administrators; IT administrators.

**Key requirements.** Online submission; unique reference number and tracking; role-based staff processing; status history with accountable updates; management reporting.

**Expected benefits.** Students gain clear routing and self-service status. Personnel spend less time responding to repetitive questions and can prioritize work consistently. Management gains evidence for staffing and service improvements.

**Recommendation.** The university should proceed. The problem analysis shows repeated, organization-wide failures caused by decentralized records; the 12-week plan delivers a focused MVP; and the requirements address the highest-value needs while keeping complex integrations outside the first release. Supabase provides a practical centralized database, authentication, private file storage, and access controls for this initial deployment.
