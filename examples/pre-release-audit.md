# Flutter Pre-Release Production Audit

Use this prompt for a final read-only production-readiness review before
shipping a Flutter release.

## Prompt

Perform a deep pre-release production-readiness audit of this Flutter
application.

Explicitly load and follow `flutter-production-audit`.

Use all relevant specialist and official Dart/Flutter skills required by the
project surfaces that actually exist.

This is Audit Mode.

Do not modify, create, delete, rename, format, refactor, or generate project
files.

Do not implement fixes.

Review the project systematically rather than sampling only recently changed
files.

Trace production-critical flows end-to-end where relevant:

UI → state → domain/business logic → repository/service →
persistence/network → platform integration.

Pay particular attention to release-sensitive areas that actually exist,
including where applicable:

- startup and initialization
- authentication/session behavior
- persistence and migrations
- networking and failure handling
- state-management correctness
- concurrency and repeated actions
- performance and resource lifetime
- background work
- notifications/deep links
- permissions
- platform-specific integrations
- localization and RTL
- responsive/adaptive UI
- accessibility
- release configuration
- environment/configuration handling
- production-critical user journeys

Apply the confidence model strictly:

- Confirmed
- Likely
- Needs verification

Keep static inspection, automated tests, measured coverage, runtime validation,
device validation, and release-build validation separate.

Do not claim production readiness merely because static analysis or automated
tests pass.

Report:

- production-readiness coverage summary
- release blockers
- findings ordered by severity
- Needs-verification items
- runtime/device checks still required
- release/configuration checks still required
- prioritized implementation plan
- one overall production-readiness verdict

Stop before implementation.