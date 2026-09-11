# Full Flutter Project Audit

Use this prompt when you want Antigravity to deeply review a Flutter project without modifying any files.

## Prompt

Perform a deep, full-project production-readiness audit of this Flutter application.

Use `flutter-production-audit` as the primary orchestration skill and proactively use all relevant available custom and official Dart/Flutter skills.

Understand the application as a complete system.

Do not modify any files.
Do not implement fixes yet.
Do not refactor anything.

Review the entire system, not only obvious or currently open files.

Trace important flows end-to-end across:

UI → state → business logic → repositories/services → persistence/network/platform code.

Actively investigate:

- bugs and incorrect logic
- crashes and runtime failure paths
- hidden edge cases
- async/concurrency/race-condition issues
- lifecycle issues
- stale or duplicated state
- initialization problems
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
- localization issues
- RTL/LTR issues
- accessibility problems
- responsive layout risks
- Android-specific problems
- iOS-specific problems
- permissions and platform configuration
- dependency misuse
- deprecated APIs
- security/privacy issues
- maintainability risks likely to cause future bugs

Do not report theoretical issues merely to increase the number of findings.

For each finding include:

1. Severity: Critical / High / Medium / Low
2. File or component
3. Exact problem
4. Why it matters
5. Realistic trigger
6. Recommended fix
7. Risks or dependencies

Distinguish findings as:

- Confirmed
- Likely
- Needs verification

Then create a prioritized implementation plan.

Do not make code changes until the implementation plan is approved.
