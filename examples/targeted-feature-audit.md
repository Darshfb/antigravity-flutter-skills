# Targeted Flutter Feature Audit

Use this prompt to deeply review one Flutter feature or user flow without
turning the task into a full-project audit.

## Prompt

Perform a deep production-readiness audit of the following Flutter feature or
flow:

[Describe the feature or flow here]

Explicitly load and follow `flutter-production-audit`.

Use the relevant specialist and official Dart/Flutter skills based on the
execution path and evidence found during the audit.

Do not load unrelated specialist skills mechanically.

This is Audit Mode.

Do not modify, create, delete, rename, format, refactor, or generate project
files.

Do not implement fixes.

Trace the feature end-to-end where applicable:

UI → state → domain/business logic → repository/service →
persistence/network → platform integration.

Inspect surrounding shared code when necessary to understand the feature
correctly, but do not silently expand this into a full-project audit.

Apply the confidence model strictly:

- Confirmed
- Likely
- Needs verification

Do not overclaim runtime, device, performance, coverage, or production behavior
beyond the available evidence.

Report:

- reviewed scope
- traced execution paths
- evidence-backed findings ordered by severity
- affected files/components
- Needs-verification items
- recommended fixes
- prioritized implementation plan
- runtime/device checks still required
- targeted production-readiness conclusion

Stop before implementation.