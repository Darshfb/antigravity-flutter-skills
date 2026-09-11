# Full Flutter Project Audit

Use this prompt for a read-only, full-project production-readiness review.

## Prompt

Perform a deep, full-project production-readiness audit of this Flutter
application.

Explicitly load and follow `flutter-production-audit`.

Use all relevant specialist and official Dart/Flutter skills when required by
the audit.

This is Audit Mode.

Do not modify, create, delete, rename, format, refactor, or generate project
files.

Do not implement fixes.

Review the application systematically rather than sampling a few obvious files.

Trace production-critical flows end-to-end where relevant:

UI → state → domain/business logic → repository/service →
persistence/network → platform integration.

Apply the confidence model strictly:

- Confirmed
- Likely
- Needs verification

Do not overclaim runtime, device, performance, coverage, or production-readiness
results beyond the available evidence.

For a full-project audit, include:

- production-readiness coverage summary
- evidence-backed findings ordered by severity
- Needs-verification items
- prioritized implementation plan
- runtime/device/release checks still required
- one overall production-readiness verdict

Do not make any code changes.

Stop after the audit and implementation plan.