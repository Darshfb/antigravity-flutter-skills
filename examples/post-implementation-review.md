# Post-Implementation Review

Use this prompt after an explicitly authorized implementation has been completed
in the current conversation.

Do not use this prompt to start new implementation work.

## Prompt

Run the final review gate for the implementation that was explicitly authorized
and completed in this conversation.

Explicitly load and follow `flutter-review-gate`.

Use relevant specialist and official Dart/Flutter skills only where required to
validate the implemented changes.

Do not expand the authorized implementation scope.

Inspect the final diff and trace the changed execution paths.

Only make narrow corrective edits when they are both:

1. introduced by the authorized implementation, and
2. within the already authorized scope.

Do not fix unrelated pre-existing issues.

Validate as far as the available environment allows.

Keep these forms of evidence separate:

- static analysis
- automated tests
- measured coverage
- runtime validation
- device/platform validation
- release-build validation

Do not claim validation that was not actually performed.

Report:

- implemented scope reviewed
- final diff assessment
- corrective edits made, if any
- static-analysis result
- automated-test result
- whether analysis/tests were run after allowed corrective edits
- runtime/device/release checks performed
- checks still missing
- deferred unrelated findings
- final validation classification

Use the review gate's validation classification:

- Validated
- Partially validated
- Not validated

Stop after the final validation report.