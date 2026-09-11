---
name: flutter-codebase-conventions
description: Makes Flutter code changes match the existing project and reuse existing widgets, services, helpers, styles, assets, and conventions. Use whenever writing or modifying Flutter code, or when flagging duplicate components and inconsistent patterns during a review. Governs style and consistency of edits; does not itself authorize making edits — respect the calling task's mode.
---

# Flutter Codebase Conventions

New code should look like it belongs to the existing project.

This skill governs how code is written or reviewed for consistency. It does
not grant permission to modify files during a read-only audit.

## Reuse before create

Before creating a new:

- widget
- button
- card
- dialog
- bottom sheet
- input
- service
- repository
- helper
- extension
- utility
- formatter
- validator
- error/result type
- platform abstraction
- localization helper
- persistence helper
- navigation helper

search the codebase for existing functionality serving the same role.

Search by:

- role/responsibility
- type/class suffix
- related feature
- shared/common/core directories
- likely call sites
- naming variants

Do not search only for the exact name you expect.

Read likely matches before deciding to create something new.

## Semantic equivalence before reuse

Similarity is not enough.

Before reusing, extending, or consolidating two implementations, determine
whether they actually have the same semantics and reasons to change.

Check:

- expected behavior
- callers
- state/lifecycle assumptions
- error behavior
- persistence/network semantics
- localization requirements
- platform differences
- feature-specific rules
- future change pressure

Two components can look nearly identical while representing different
responsibilities.

Do not merge them merely because their current implementation is similar.

## Reuse vs extend vs create fresh

Prefer reuse when an existing component already matches the required role and
semantics.

Prefer extension only when the existing abstraction remains coherent.

Before extending a shared component, verify:

- existing callers keep their behavior unchanged
- the new behavior remains generic
- the API does not become flag-heavy or branch-heavy
- feature-specific concepts do not leak into shared code
- the abstraction still has one understandable responsibility
- regression risk to existing callers is acceptable

Warning signs of a forced extension include:

- multiple booleans controlling unrelated behavior
- feature names appearing in shared APIs
- many conditional branches for individual callers
- unrelated optional parameters
- callers needing special-case knowledge

If satisfying one new caller would distort the shared abstraction, prefer a
focused new component.

Reuse is a means to consistency and maintainability, not a goal by itself.

## Shared vs feature-local

Do not move code into shared/core solely because more than one feature uses it.

Promote functionality when the responsibility is genuinely shared and stable.

Keep functionality feature-local when:

- semantics differ by feature
- the abstraction would need feature-specific branches
- future changes are likely to diverge
- sharing would increase coupling
- the shared API would become harder to understand than the local code

A small amount of duplication may be safer than premature centralization.

## House style

Match existing project conventions when they are coherent and intentional.

Consider:

- file naming
- folder organization
- Page vs Screen naming
- imports
- state-management approach
- dependency injection
- routing
- models
- error handling
- widget composition
- theme usage
- repository/service boundaries
- async patterns
- testing style

Do not introduce a competing architectural pattern without a concrete reason.

Do not force every feature into identical structure when the project already
contains legitimate feature-specific differences.

## Styling

Prefer existing:

- theme
- typography
- spacing
- colors
- radius
- component patterns

Avoid hardcoded values when an appropriate shared value already exists.

Do not introduce a new design-token system merely because one does not exist.

Do not force a shared style abstraction for values that are legitimately
feature-specific.

## Assets

Never invent an asset path.

Confirm:

- the asset exists
- the declared path is correct
- `pubspec.yaml` includes it when needed
- platform-specific assets are placed appropriately

If an asset is missing, report that instead of assuming it exists.

## Dependencies

Before adding a package:

- check whether the project already solves the problem
- check whether Flutter/Dart itself reasonably solves it
- check whether an existing dependency already provides the capability
- consider maintenance status when materially relevant
- consider package size/platform impact when materially relevant
- consider license when relevant to distribution

Do not recommend replacing a dependency merely because another package is
newer, more popular, or more fashionable.

A dependency is a problem only when there is a concrete project-level reason,
such as:

- unsupported target platform
- unresolved compatibility issue
- known production defect affecting this project
- abandonment that creates a real maintenance/release risk
- duplicate dependency roles with meaningful cost or inconsistency

## Duplication

Flag meaningful duplication, not visual or textual similarity.

Meaningful duplication is duplication that creates realistic risk of:

- inconsistent behavior
- repeated bug fixes
- divergent business rules
- multiple sources of truth
- inconsistent UI behavior
- duplicated platform logic
- conflicting persistence/network handling
- unnecessary maintenance burden

Do not create an abstraction merely to remove a few duplicated lines.

## Intentional duplication and migration states

Before reporting duplication, check whether multiple implementations are
intentional.

Examples:

- old/new implementation during migration
- platform-specific implementations
- experiment/feature-flag variants
- compatibility layer
- deprecated code still serving older flows
- test-only implementation
- temporary adapter during refactor

Do not consolidate intentional parallel implementations without understanding
their lifecycle and callers.

If duplication appears temporary, identify whether cleanup is actually due
before reporting it as a production issue.

## Full-project consistency review

During a full-project production audit, inspect consistency across features
rather than only files already being changed.

Use search before concluding duplication exists.

Look for repeated roles such as:

- widgets serving the same functional role
- duplicated business rules
- repeated validation
- duplicate formatters/parsers
- overlapping helpers
- parallel services/repositories
- repeated persistence/query logic
- duplicate API/network handling
- duplicated error mapping
- repeated localization helpers
- duplicate navigation helpers
- repeated platform abstractions
- duplicated state ownership
- multiple sources of truth
- feature-local implementations of existing shared functionality

For each suspected duplicate, inspect callers and semantics before reporting it.

## Convention drift

During a full-project review, look for meaningful convention drift.

Examples:

- error handling
- dependency injection
- repository boundaries
- state ownership
- loading/failure representation
- localization
- theme/style usage
- navigation
- persistence access
- platform-service access
- logging
- serialization

Do not report harmless stylistic differences.

Distinguish:

- style drift
- structural drift
- behavior drift

Style drift alone is usually low-value unless it causes maintenance or
readability problems.

Behavior drift is more important when equivalent responsibilities now behave
differently.

Report convention drift only when it creates a realistic:

- correctness problem
- maintenance burden
- duplication risk
- testing inconsistency
- UX inconsistency
- architectural confusion

## Consistency vs correctness

Do not change correct behavior merely to make code look more uniform.

Consistency is secondary to:

- correctness
- product semantics
- platform behavior
- feature-specific requirements

If two patterns are both valid and already established, do not force
convergence without clear benefit.

## Evidence discipline

Do not report duplication or inconsistency solely from names, file structure,
or superficial code similarity.

A confirmed duplication finding should identify:

- the implementations involved
- their actual responsibility
- their callers
- why the semantics overlap
- the concrete risk created by keeping both

If responsibility or semantics remain unclear, classify the finding as
Needs verification or continue investigating.

Do not inflate severity merely because duplicated code exists.

## Reporting

For duplication or consistency findings, report:

- relevant files/components
- shared or conflicting responsibility
- supporting evidence
- actual risk
- whether the safer direction is:
  - reuse
  - extension
  - consolidation
  - intentional separation
  - no change
- confidence in the finding

If the relationship between implementations is unclear, investigate callers
and semantics before reporting them as duplicates.

During a read-only audit, report findings only.

Do not consolidate, move, rename, refactor, or restructure code without
explicit authorization.

## Final principle

The goal is not maximum reuse.

The goal is:

**coherent code with the right boundaries, minimal accidental duplication,
and abstractions that remain understandable as the project evolves.**