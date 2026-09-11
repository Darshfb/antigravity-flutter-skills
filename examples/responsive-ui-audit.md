# Flutter Responsive and Adaptive UI Audit

Use this prompt to review Flutter layouts across supported screen sizes,
orientations, window sizes, and form factors.

## Prompt

Perform a focused responsive and adaptive UI audit of this Flutter application.

Target screen or flow, if known:

[Describe the screen/flow, or write "General responsive UI review"]

Explicitly load and follow `flutter-production-audit`.

Explicitly load and follow `flutter-responsive`.

Use `flutter-a11y-rtl` and other relevant specialist or official Dart/Flutter
skills when the affected UI requires them.

This is Audit Mode.

Do not modify project files or implement layout fixes.

Reason from Flutter's actual constraint system rather than applying generic
responsive patterns mechanically.

Review relevant surfaces for:

- bounded vs. unbounded constraint problems
- Row/Column/Flex behavior
- nested scrolling
- fixed dimensions around dynamic content
- text scaling and longer translations
- meaningful breakpoints
- safe areas and system insets
- keyboard appearance
- orientation changes
- live window resizing
- split-screen/multi-window behavior
- tablet/desktop/foldable layouts where supported
- list/grid adaptation
- platform interaction patterns where relevant

Do not assume that fixed dimensions, MediaQuery, SingleChildScrollView,
shrinkWrap, Expanded, or physical alignment values are bugs by themselves.

Apply the confidence model strictly:

- Confirmed
- Likely
- Needs verification

Report:

- reviewed screens/layout surfaces
- confirmed layout problems
- likely responsive risks
- constraint root causes
- affected screen sizes/form factors
- Needs-verification scenarios
- recommended fixes
- prioritized implementation plan
- device/window-size checks still required

Stop before implementation.