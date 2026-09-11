# Audit and Fix

Use this prompt when you want Antigravity to audit the project and fix confirmed issues.

## Prompt

Perform a full production-readiness audit of this Flutter project and fix confirmed issues.

Use `flutter-production-audit` as the primary orchestration skill and proactively use all relevant available custom and official Dart/Flutter skills.

Understand the application as a complete system before making changes.

Review the entire system, not only obvious or currently open files.

Trace important flows end-to-end across:

UI → state → business logic → repositories/services → persistence/network/platform code.

Actively investigate:

- real bugs and incorrect logic
- runtime failure paths
- edge cases
- async/concurrency/race-condition issues
- lifecycle problems
- stale or duplicated state
- initialization issues
- error-handling gaps
- offline and timeout scenarios
- malformed or unexpected API data
- navigation problems
- persistence/cache consistency
- resource leaks
- unnecessary rebuilds
- expensive build work
- inefficient lists/images/caching
- duplicate widgets or logic
- localization problems
- RTL/LTR issues
- accessibility problems
- responsive layout risks
- Android-specific problems
- iOS-specific problems
- permissions and platform configuration
- dependency misuse
- deprecated APIs
- practical security/privacy issues

Preserve the existing architecture and technology choices unless they are the source of a concrete problem.

Before creating any new widget, service, helper, repository, style, utility, or abstraction, search the project for an existing implementation serving the same role.

Fix:

- confirmed Critical issues
- confirmed High issues
- worthwhile Medium issues

Do not perform speculative refactors.
Do not perform cosmetic rewrites.
Do not introduce unnecessary dependencies.
Do not perform micro-optimizations without meaningful benefit.

Use `flutter-codebase-conventions` before introducing new components.
Use `flutter-state-management` when state flows are affected.
Use `flutter-performance` for meaningful performance issues.
Use `flutter-responsive` for layout-related changes.
Use `flutter-a11y-rtl` for user-facing UI when relevant.

Do not repeatedly run static analysis or the full test suite while implementing.

When all changes are complete, use `flutter-review-gate`.

Final validation:

1. Format changed Dart files if needed.
2. Run static analysis once.
3. Fix problems introduced by the changes.
4. Run relevant tests once at the end.
5. Report anything that could not be validated.

At the end provide a concise report containing:

- issues found
- issues fixed
- files significantly affected
- validation results
- remaining risks or items needing verification
