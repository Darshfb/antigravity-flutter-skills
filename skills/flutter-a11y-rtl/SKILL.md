---
name: flutter-a11y-rtl
description: Reviews Flutter user interfaces for accessibility, RTL/LTR correctness, semantics, touch targets, text scaling, form accessibility, focus/keyboard behavior, dynamic-content announcements, and localization-related UI issues. Use for Arabic/multilingual apps, accessibility reviews, user-facing widgets, icons, padding, alignment, forms, dialogs, or localization-sensitive UI. Reviewing does not imply permission to edit — respect the calling task's mode.
---

# Flutter Accessibility and RTL

Review accessibility and RTL/LTR behavior as real user experience concerns,
not as checklist compliance.

Use official Flutter accessibility tooling or agents when useful.

If invoked during a read-only review, report findings only. Do not edit files.

Do not report theoretical accessibility violations without a realistic user
impact or enough evidence to support the claim.

## Core principle

Separate:

- what static inspection can confirm
- what is likely from the implementation
- what requires runtime/device verification

Static code can confirm some structural accessibility problems, but it cannot
fully prove:

- TalkBack behavior
- VoiceOver behavior
- focus traversal at runtime
- actual contrast after all rendering/opacity/theme effects
- dynamic screen-reader announcements
- real text clipping at every supported text scale
- platform-specific accessibility behavior

When runtime behavior matters and cannot be established statically, classify
the issue as **Needs verification** rather than guessing.

## Directionality

Prefer directional concepts such as start/end when the meaning is directional.

Review where relevant:

- `EdgeInsets`
- `Alignment`
- `Positioned`
- `BorderRadius`
- directional icons
- navigation affordances
- horizontal layouts
- mixed-direction content

Do not mechanically replace every physical left/right value.

Physical direction may be intentional.

Examples include:

- phone-number layouts
- charts/graphs
- maps
- media controls
- explicitly physical animation
- platform-specific visual conventions

Before reporting a directionality issue, inspect enough context to determine
whether the direction is semantic or intentionally physical.

A physical left/right value is not automatically an RTL bug.

## Icons and mirroring

Do not mirror every icon automatically.

Directional icons may need mirroring, such as:

- back/forward arrows
- some navigation/disclosure arrows
- some undo/redo affordances

Non-directional icons usually should not mirror, such as:

- search
- camera
- play/pause
- clock
- location markers
- microphone
- favorite/bookmark

Respect Flutter/platform automatic mirroring when it already provides the
correct behavior.

Do not add custom mirroring on top of platform/framework behavior without a
verified need.

## Text scaling

Review UI behavior with increased text scale.

Look for:

- fixed-height containers around dynamic text
- clipped labels
- buttons that cannot expand
- tightly constrained rows
- truncated translated text
- overlapping text
- dialogs/bottom sheets that cannot accommodate larger content

Do not disable or clamp text scaling merely to preserve visual appearance.

Do not assume text clipping exists just because a fixed dimension is present.

Consider:

- actual text length
- number of lines
- available constraints
- localization
- surrounding layout behavior

If static inspection cannot establish the rendered result, mark it for visual
verification.

## Semantics

Check meaningful interactive controls for accessible identification and
actions.

Review:

- icon-only controls
- custom gesture controls
- custom sliders
- custom toggles
- drag handles
- swipe actions
- compound controls
- custom-rendered content
- decorative content accidentally exposed as meaningful

Do not add `Semantics` wrappers mechanically.

Built-in Flutter widgets often already provide appropriate semantics.

Check for both:

- missing semantics
- redundant or incorrect semantics

Pay attention to:

- `ExcludeSemantics`
- `MergeSemantics`
- duplicate labels
- incorrect button/toggle state
- hidden meaningful children
- confusing traversal order

Custom interaction patterns should expose an accessible equivalent when needed.

## Touch targets

Review the actual tappable area, not only the visible icon size.

A visually small icon may still have an adequate interaction target because of:

- padding
- parent constraints
- `IconButton`
- `InkResponse`
- gesture hit-test area

Do not report a touch-target violation from visual icon dimensions alone.

Inspect the hit area.

If the effective target size cannot be determined confidently from code, mark
it as needing verification.

## Visual accessibility

Important state or meaning should not depend on color alone.

Review patterns such as:

- success/error state
- selected/unselected state
- enabled/disabled state
- chart categories
- warnings
- status indicators

Where practical, important state should also be communicated through:

- text
- iconography
- shape
- semantics
- another non-color cue

Do not guess contrast ratios from partial information.

Inspect contrast only when the effective foreground/background colors are
known sufficiently from code.

If the rendered color depends on:

- runtime theme
- opacity
- overlays
- dynamic backgrounds
- images
- blending
- platform rendering

mark contrast as requiring visual/tool verification.

## Forms

Review forms for:

- persistent accessible labels
- validation feedback
- error association
- required-field communication
- keyboard behavior
- logical field traversal
- submission behavior
- custom input semantics

Placeholder/hint text should not be the only persistent identification for an
important input when it disappears during entry.

Do not assume a form is inaccessible merely because `labelText` is absent.

Inspect the complete surrounding UI and semantics.

For validation errors, check whether the user can understand:

- which field failed
- what the problem is
- what action is needed

## Dynamic content and announcements

Meaningful asynchronous state changes may need accessible announcements.

Examples:

- submission failed
- validation error appeared
- important content finished loading
- action completed successfully
- critical status changed

Do not announce every state transition.

Avoid:

- noisy repeated announcements
- announcing purely visual changes with no user relevance
- duplicate announcements from built-in semantics plus manual announcement

Use announcements only when screen-reader users would otherwise miss important
state changes.

If actual announcement behavior depends on runtime assistive technology, mark
it as needing device/runtime verification.

## Modals, dialogs, sheets, and focus

Review user-facing modal surfaces when relevant.

Check:

- initial focus behavior
- logical focus order
- focus containment
- background traversal while modal is open
- focus restoration on close
- keyboard insets
- dismissal behavior
- accessible modal title/purpose

Do not assume focus management is broken solely because explicit focus code is
absent; built-in Flutter/platform behavior may already handle it.

Investigate the actual widget composition before reporting a defect.

## Keyboard and focus

For desktop, web, TV, or other keyboard-relevant targets, check:

- all important controls are reachable
- focus order is sensible
- focus indicators are visible
- custom controls can be activated from keyboard
- shortcuts do not block ordinary navigation
- focus does not become trapped unexpectedly

Do not require desktop/keyboard behavior for projects that do not target those
interaction modes.

## Localization

Review user-facing localization for more than key existence.

Inspect when relevant:

- hardcoded strings
- missing translations
- untranslated fallback content
- concatenated translated fragments
- interpolation
- pluralization
- date formatting
- time formatting
- number formatting
- punctuation around interpolated values
- Arabic/Latin mixed text
- long translated text
- localized validation/error messages
- notification/dialog/platform-visible strings

Do not assume identical key counts guarantee localization correctness.

Key parity does not prove:

- translation quality
- correct interpolation
- correct plural semantics
- appropriate formatting
- layout compatibility

Do not report translation quality problems unless there is actual evidence.

## Bidirectional text

Pay special attention to mixed Arabic/Latin/numeric content.

Examples:

- URLs
- email addresses
- phone numbers
- IDs
- dates
- times
- prices
- English product names inside Arabic sentences

Check for realistic problems involving:

- punctuation placement
- unexpected reordering
- confusing mixed-direction runs
- incorrect alignment assumptions

Do not force an entire string to one direction when only a segment needs
directional isolation.

Use platform/Flutter bidi behavior where it already handles the case
correctly.

## Full-project accessibility and RTL coverage

During an explicitly requested full-project production audit, systematically
consider the user-facing surfaces that actually exist.

Typical coverage areas include:

- primary navigation
- forms
- dialogs
- bottom sheets
- menus
- icon-only controls
- custom gestures
- loading/error/success states
- lists/cards
- localization-sensitive layouts
- Arabic and English flows
- RTL/LTR navigation
- text scaling
- semantics
- touch targets
- modal focus
- keyboard/focus where relevant
- mixed-direction content

Do not claim the entire UI was reviewed because a few representative screens
were inspected.

Inspect shared UI primitives plus enough production-critical feature screens to
support the conclusion.

If the project is large and coverage is incomplete, mark areas as:

- Not reviewed
- Needs runtime/device verification

rather than implying complete accessibility readiness.

## Evidence discipline

Classify findings as:

- **Confirmed**
- **Likely**
- **Needs verification**

A static structural issue may be Confirmed while its real assistive-technology
impact still requires runtime verification.

Examples:

- Confirmed: a custom icon-only GestureDetector exposes no meaningful label.
- Needs verification: TalkBack users cannot discover the control in the actual
  rendered flow.

- Confirmed: a fixed-height widget contains dynamic localized text.
- Needs verification: Arabic text clips at the supported maximum text scale.

- Confirmed: success and failure differ only by hardcoded colors.
- Likely: users with some forms of color-vision deficiency may have difficulty
  distinguishing them.

Do not inflate severity using an unverified runtime consequence.

Do not assume the presence of `Semantics` proves accessibility.

Do not assume the absence of explicit `Semantics` proves inaccessibility.

Inspect actual widget behavior and built-in semantics first.

## Cargo-cult guardrails

Do not mechanically:

- wrap every widget in `Semantics`
- replace every left/right value with start/end
- mirror every icon
- add live announcements to every async state
- increase every visible icon size
- force every label to multiple lines
- disable text scaling
- add custom focus management when built-in behavior is sufficient

Use the simplest change that fixes a verified usability problem.

## Reporting

For each finding, include:

- file/component
- affected user interaction
- exact issue
- evidence
- realistic trigger
- likely or verified impact
- recommended direction
- confidence
- runtime/device verification required

For full-project audits, also report which accessibility/RTL surfaces were
actually reviewed and which remain unverified.

Use evidence-bounded language.

Prefer:

- "No meaningful static RTL issue was identified in the reviewed flow."

over:

- "RTL is fully correct."

Prefer:

- "Relevant controls expose appropriate semantics in the inspected code."

over:

- "The app is fully accessible."

Do not claim:

- full accessibility
- VoiceOver compatibility
- TalkBack compatibility
- correct contrast everywhere
- no RTL issues
- no text-scaling issues

unless the required evidence actually supports those claims.

## Final principle

This skill answers:

**"What accessibility, localization-sensitive UI, and RTL/LTR risks are
supported by the implementation, and what still requires runtime or assistive-
technology verification?"**

It does not answer:

**"Can static inspection prove the application is fully accessible on every
device and assistive technology?"**