# Flutter Accessibility and RTL Audit

Use this prompt to review accessibility, RTL/LTR behavior, semantics, text
scaling, forms, focus, and localization-sensitive UI.

## Prompt

Perform a focused accessibility and RTL/LTR audit of this Flutter application.

Target screen or flow, if known:

[Describe the screen/flow, or write "General accessibility and RTL review"]

Explicitly load and follow `flutter-production-audit`.

Explicitly load and follow `flutter-a11y-rtl`.

Use `flutter-responsive` and other relevant specialist or official Dart/Flutter
skills when the affected UI requires them.

This is Audit Mode.

Do not modify project files or implement fixes.

Review relevant UI surfaces for:

- directionality
- directional vs. physical positioning
- icon mirroring
- text scaling
- semantics
- custom gesture accessibility
- actual touch-target size
- color-only state communication
- forms and validation feedback
- dynamic-content announcements
- dialogs, focus, and focus restoration
- keyboard navigation where supported
- hardcoded user-facing text
- localization-sensitive layouts
- Arabic/Latin/numeric bidirectional content
- longer translations and clipping

Do not mechanically add Semantics, mirror every icon, replace every left/right
value, or disable text scaling to preserve layout.

Apply the confidence model strictly:

- Confirmed
- Likely
- Needs verification

Do not claim screen-reader, contrast, or device behavior that static evidence
cannot establish.

Report:

- reviewed accessibility/RTL surfaces
- confirmed accessibility or directionality problems
- likely risks
- Needs-verification items
- affected screens/components
- user impact
- recommended fixes
- prioritized implementation plan
- TalkBack/VoiceOver/device checks still required

Stop before implementation.