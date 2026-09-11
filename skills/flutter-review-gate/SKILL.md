---
name: flutter-review-gate
description: Final validation gate for Flutter changes that were explicitly authorized and already implemented — checks scope, correctness, consistency, relevant specialist domains, formatting, static analysis, tests, and runtime/platform verification, and reports Validated / Partially validated / Not validated. Use only after implementation, never to initiate new changes. Does not authorize unrelated edits and must not run as part of a read-only audit.
---

# Flutter Review Gate

## Activation guard

Run this only after implementation was explicitly authorized by the user
and has already been carried out.

This skill validates changes that already exist. It never initiates,
expands, or justifies new implementation work.

Do not run it:

- during a read-only audit or review-only task
- as authorization to implement newly discovered issues
- repeatedly after every small edit

If invoked with no prior authorized implementation in this conversation,
say so and stop.

Do not claim this skill was used, followed, or passed unless its
instructions were actually loaded and applied during the current task.

## Scope discipline

Narrow corrective edits are allowed only when all are true:

- implementation was already authorized
- the issue was introduced by that implementation
- the correction stays within the authorized scope

Do not automatically:

- fix unrelated pre-existing warnings
- fix unrelated findings
- expand scope
- introduce unrelated refactors
- change unrelated dependencies
- opportunistically clean nearby code

Report those issues instead. They require new authorization.

## Specialist routing

Determine which specialist domains are actually affected by the changed code.

When a matching specialist skill exists, explicitly load and follow it before
declaring validation complete.

Typical routing:

- state, Bloc/Cubit, async flows, concurrency, ordering, cancellation,
  optimistic updates, subscriptions → `flutter-state-management`
- performance, memory, timers, resources, I/O, startup, caching, polling,
  background work → `flutter-performance`
- UI constraints, layout, responsiveness, multi-device behavior →
  `flutter-responsive`
- accessibility, semantics, forms, text scaling, localization-related UI,
  RTL/LTR → `flutter-a11y-rtl`
- widgets, services, repositories, helpers, abstractions, dependencies,
  project conventions → `flutter-codebase-conventions`

Use specialists based on actual changed scope, not mechanically.

Do not load unrelated skills just to satisfy a checklist.

Do not substitute general knowledge or an informal equivalent review for an
available specialist skill that applies.

Do not claim a specialist skill was used unless its instructions were actually
loaded and applied.

If a required specialist is unavailable, state that explicitly.

## Step 1 — Scope review

Inspect the final diff or changed files against the authorized implementation.

Confirm:

- requested behavior was implemented
- unrelated behavior was not changed unnecessarily
- scope did not silently expand
- architecture was preserved unless explicitly authorized otherwise
- no accidental duplicate implementation was introduced

Use `flutter-codebase-conventions` when applicable.

## Step 2 — Correctness

Review changed execution flows, not just changed lines.

Check when relevant:

- logic and state transitions
- null/empty-state handling
- async lifecycle safety
- concurrency and ordering
- cancellation semantics
- stale or out-of-order results
- failure and recovery paths
- persistence consistency
- navigation
- timers/subscriptions
- resource cleanup
- background/foreground transitions
- process restart/restoration assumptions
- platform integration behavior

Trace important flows end-to-end when needed.

If state, async behavior, Bloc/Cubit, event ordering, concurrency, or
cancellation changed, explicitly use `flutter-state-management`.

## Step 3 — Codebase consistency

Use `flutter-codebase-conventions` when applicable.

Confirm changed or new code:

- follows project conventions
- reuses appropriate existing components
- does not duplicate existing services/helpers/widgets unnecessarily
- does not introduce a competing architectural pattern
- does not make shared abstractions feature-specific without justification

## Step 4 — UI

When user-facing UI changed:

- use `flutter-responsive` for layout, constraints, responsiveness, and
  multi-device behavior
- use `flutter-a11y-rtl` for accessibility, semantics, localization-related
  UI, text scaling, and RTL/LTR behavior

Skip this step only when UI is genuinely unaffected, and state that it was
not applicable.

## Step 5 — Performance and resources

When changes affect lists, state subscriptions, heavy UI, images, memory,
I/O, startup, caching, timers, polling, background work, controllers,
subscriptions, or other resources, explicitly use `flutter-performance`.

Check for regressions introduced by the implementation.

Do not claim measurable runtime improvement from static inspection alone when
profiling is required.

## Step 6 — Format

Format changed Dart files when necessary.

Do not format unrelated files.

If formatting modifies files, keep changes inside the authorized scope.

If formatting cannot be performed, state that explicitly.

## Step 7 — Static analysis

Run the project's static analysis once after implementation and any allowed
corrective edits are complete.

Fix analyzer issues only when:

- they were introduced by the authorized implementation
- the fix remains within scope

Do not silently fix unrelated existing warnings.

Record the actual analyzer result.

If analysis cannot run, say so.

## Step 8 — Tests and runtime verification

Run relevant automated tests once at the end when tests exist and apply.

Prefer tests covering the changed behavior unless the task or project
requires a full suite.

Do not treat passing tests as proof of behavior they do not exercise.

Keep these forms of evidence separate:

- tests passing
- measured code coverage
- behavioral coverage of changed flows
- static analysis
- runtime/device/platform validation
- release-build validation

Passing tests do not establish percentage-based code coverage.

Do not claim:

- "100% covered"
- "fully covered"
- any numerical coverage percentage

unless an actual coverage report such as LCOV or equivalent was generated
and inspected.

When measured coverage is unavailable, use qualitative wording such as:

- Strong automated coverage observed for the changed flows
- Relevant changed flows have automated tests
- Partial automated coverage
- Important changed path appears untested
- Coverage percentage was not measured

If correctness depends on behavior that cannot be verified in the current
environment, explicitly mark it as requiring runtime/device/manual validation.

Examples:

- background execution
- process death/restoration
- OS notifications or alarms
- permissions
- platform channels
- physical-device performance
- screen-reader behavior
- OEM/device-specific behavior
- lifecycle behavior requiring a real device
- release-only configuration

Passing automated checks does not prove any of the above unless that behavior
was actually exercised in an appropriate environment.

## Step 9 — Final report

Report:

- skills actually loaded and followed
- gate steps performed
- steps skipped as not applicable
- steps that could not be completed
- files/change scope reviewed
- corrective edits made during validation, if any
- analyzer result
- tests run and their result
- measured coverage result, if generated
- runtime/device/release behavior still requiring verification
- unrelated findings deferred for new authorization
- whether analyzer/tests were run after any allowed corrective edits

Then classify the result as exactly one of:

### 🟢 VALIDATED

Use only when all applicable validation required to establish correctness was
completed successfully.

Typically this means:

- scope matches authorization
- applicable specialist reviews were completed
- analyzer passed when applicable
- relevant tests passed when applicable
- no material changed behavior remains unverified

Do not use this classification solely because `flutter analyze` and
`flutter test` passed.

### 🟡 PARTIALLY VALIDATED

Use when completed validation passed, but some material verification could not
be performed.

Examples:

- relevant platform/device behavior could not be exercised
- background/process-death behavior still needs device testing
- required runtime profiling could not be performed
- important changed paths lack meaningful test coverage
- a required specialist or validation capability was unavailable
- release-only behavior remains unverified

State exactly what remains unverified.

### 🔴 NOT VALIDATED

Use when:

- static analysis fails because of the implementation
- relevant tests fail
- the implementation violates the authorized scope
- a correctness regression remains unresolved
- required validation fails
- validation cannot progress far enough to establish reasonable confidence

## Evidence discipline

Do not let the final wording exceed the evidence.

Avoid unsupported claims such as:

- "fully tested"
- "100% covered"
- "no regressions"
- "cannot crash"
- "works on all devices"

Prefer bounded wording such as:

- "Relevant automated tests passed."
- "No regression was identified in the reviewed changed flow."
- "Coverage percentage was not measured."
- "Device/runtime verification is still required."

Passing tests, measured coverage, behavioral correctness, and platform/runtime
validation are different kinds of evidence.

## Finding status format

If validation discovers an issue in the authorized implementation, keep
severity and confidence separate.

Severity:

- 🔴 **CRITICAL**
- 🟠 **HIGH**
- 🟡 **MEDIUM**
- 🔵 **LOW**

Confidence:

- Confirmed
- Likely
- Needs verification

Examples:

- 🔴 **CRITICAL | Confirmed**
- 🟠 **HIGH | Likely**
- 🟡 **MEDIUM | Confirmed**
- ⚪ **NEEDS VERIFICATION**

Do not inflate severity using an unverified consequence.

Do not use 🟢 OK for an area that was not actually reviewed.

## Final principle

The gate answers:

**"Were the authorized changes actually reviewed and validated enough to
support the claimed result?"**

It does not answer:

**"Is the entire project bug-free?"**

Do not expand its conclusion beyond the implemented scope.