# Flutter Bug Investigation

Use this prompt to investigate a specific Flutter bug without making changes.

## Prompt

Investigate the following issue in this Flutter project:

[Describe the bug here]

Explicitly load and follow `flutter-production-audit`.

Use the relevant specialist and official Dart/Flutter skills based on the
execution path and evidence found during the investigation.

Do not load unrelated specialist skills mechanically.

This is a read-only investigation.

Do not modify, create, delete, rename, format, refactor, or generate project
files.

Do not implement fixes.

Trace the relevant execution path end-to-end where applicable:

UI → state → domain/business logic → repository/service →
persistence/network → platform integration.

Determine whether the reported symptom is the root problem or a downstream
consequence.

Apply the confidence model strictly:

- Confirmed
- Likely
- Needs verification

Do not infer runtime behavior beyond the available evidence.

Report:

- reported/observed behavior
- traced execution path
- confirmed root cause or strongest supported hypothesis
- affected files/components
- impact
- supporting evidence
- alternative explanations still requiring verification
- recommended fix
- focused implementation plan
- runtime/device reproduction or verification still required

Stop before implementation.