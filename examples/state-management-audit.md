# Flutter State Management Audit

Use this prompt to review state ownership, asynchronous behavior, concurrency,
event semantics, cancellation, and state-driven correctness.

## Prompt

Perform a focused state-management audit of this Flutter project.

Target feature or concern, if known:

[Describe the feature/concern, or write "General state-management review"]

Explicitly load and follow `flutter-production-audit`.

Explicitly load and follow `flutter-state-management`.

Use other relevant specialist and official Dart/Flutter skills only when the
traced execution paths require them.

This is Audit Mode.

Do not modify project files or implement fixes.

Review the relevant state-management surfaces that actually exist.

Trace important state-changing operations through their complete execution
paths.

Pay particular attention where applicable to:

- state ownership and sources of truth
- event/action semantics
- ordering and concurrency
- rapid repeated user actions
- stale-result overwrites
- cancellation semantics
- whether cancellation actually cancels underlying work
- optimistic updates and rollback
- duplicate subscriptions/listeners
- lifecycle behavior
- equality and identity
- rebuild scope
- persistence synchronization
- overlapping async operations

Do not recommend concurrency strategies mechanically.

Determine whether every operation matters, only the latest result matters,
operations must remain ordered, or independent operations may safely overlap.

Apply the confidence model strictly:

- Confirmed
- Likely
- Needs verification

Report:

- reviewed state-management scope
- traced state-changing flows
- evidence-backed findings
- ordering/concurrency semantics where relevant
- source-of-truth problems
- cancellation/rollback risks where relevant
- Needs-verification items
- recommended fixes
- prioritized implementation plan
- runtime stress scenarios still required

Stop before implementation.