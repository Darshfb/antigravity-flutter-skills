# Flutter Codebase Consistency Audit

Use this prompt to review meaningful duplication, convention drift, competing
patterns, and inconsistent implementations.

## Prompt

Perform a focused codebase consistency and duplication audit of this Flutter
project.

Explicitly load and follow `flutter-production-audit`.

Explicitly load and follow `flutter-codebase-conventions`.

Use other relevant specialist and official Dart/Flutter skills when the
responsibilities being compared require them.

This is Audit Mode.

Do not modify project files.

Do not consolidate, extract, refactor, rename, or migrate code.

Search before concluding that functionality is duplicated.

Compare semantics and callers rather than relying only on similar names or code
shape.

Review relevant areas for:

- duplicated business rules
- overlapping widgets/components
- repeated validation
- duplicate formatters/parsers/helpers
- overlapping services/repositories
- repeated persistence/network logic
- duplicate error mapping
- multiple sources of truth
- inconsistent state ownership
- inconsistent DI or navigation patterns
- localization/style convention drift
- feature-local implementations of existing shared functionality

Distinguish intentional separation from harmful duplication.

Do not recommend abstraction merely to reduce line count.

Apply the confidence model strictly:

- Confirmed
- Likely
- Needs verification

Report:

- implementations compared
- responsibilities and caller semantics
- meaningful duplication or convention drift
- concrete maintenance/correctness/UX risk
- intentional duplication that should remain separate where relevant
- recommended direction: reuse, extend, consolidate, or keep separate
- prioritized implementation plan
- unresolved relationships requiring verification

Stop before implementation.