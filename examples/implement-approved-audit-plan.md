# Implement Approved Audit Plan

Use this prompt only after a production audit has already been completed and
you have explicitly approved its implementation plan.

## Prompt

Implement the previously approved production-audit plan.

This message explicitly authorizes Implementation Mode for the approved scope
only.

Explicitly load and follow `flutter-production-audit`,
`flutter-codebase-conventions`, and every relevant specialist skill required by
the affected domains.

Do not expand beyond the approved scope.

Do not fix unrelated pre-existing issues discovered during implementation;
report them separately.

Preserve the project's existing architecture unless the approved plan requires
otherwise.

After all authorized changes are complete:

1. Explicitly load and follow `flutter-review-gate`.
2. Apply any relevant specialist validation it requires.
3. Format only changed Dart files when needed.
4. Run static analysis after implementation and any allowed corrective edits.
5. Run relevant tests once at the end.
6. Report runtime/device/release verification that could not be completed.

Do not claim a skill was used unless it was actually loaded and followed.

Use the review gate's final classification:

- Validated
- Partially validated
- Not validated