---
name: flutter-responsive
description: Builds and reviews adaptive and responsive Flutter layouts across phones, tablets, desktop, web, foldables, orientation changes, live window resizing, split-screen, keyboard/inset changes, large text, and Flutter's bounded/unbounded constraint model. Use for UI work, fixed dimensions, overflows, LayoutBuilder, MediaQuery, breakpoints, multi-device support, dialogs, bottom sheets, lists/grids, or adaptive interaction patterns. Reviewing does not imply permission to edit — respect the calling task's mode.
---

# Flutter Responsive and Adaptive UI

Design for available constraints, not one screenshot size.

If invoked during a read-only review, report findings only. Do not edit files.

Focus on real layout/adaptation problems, not mechanical replacement of every
fixed value or every `MediaQuery` call.

## Core principle

Separate:

- structural constraint problems visible from code
- likely layout risks
- runtime/rendering behavior that needs visual/device verification

Static inspection can confirm some layout defects, but it cannot always prove:

- actual overflow at a given device size
- text clipping at every text scale
- keyboard overlap on every platform
- foldable hinge behavior
- pointer/keyboard interaction quality
- real window-resize behavior

When the rendered result depends on runtime constraints or platform behavior,
classify it as **Needs verification** instead of guessing.

## Constraint-system reasoning

Reason from Flutter's constraint model before proposing fixes.

Distinguish:

- bounded vs unbounded constraints
- parent constraints vs screen size
- content sizing vs flex sizing
- scrollable vs non-scrollable axes
- intrinsic sizing vs explicit sizing

### Bounded vs unbounded

An unbounded-axis problem is different from content being too large for a
bounded area.

Examples:

- `Column` inside an unbounded-height parent
- `ListView` inside another vertical scrollable
- `Expanded` inside an unbounded axis
- child expecting finite width/height when parent does not provide one

Do not fix these by adding arbitrary fixed dimensions.

Identify the actual source of the unbounded constraint.

### Row / Column / Flex

Check:

- whether children should share available space
- whether they should size to content
- whether `Expanded` or `Flexible` semantics match the intended behavior
- whether wrapping is more appropriate
- whether a fixed child legitimately needs fixed size

Do not add `Expanded` or `Flexible` mechanically just because a `Row` overflows.

### Nested scrollables

Inspect nested `ListView`, `GridView`, `SingleChildScrollView`, or other
scrollables for:

- axis conflicts
- unbounded constraints
- unnecessary `shrinkWrap`
- conflicting scroll physics
- eager layout cost from shrink-wrapped large collections
- unclear ownership of scrolling

Do not use `shrinkWrap: true` merely to silence a constraint exception.

Do not add `SingleChildScrollView` as a default overflow fix.

Use scrolling only when the content genuinely should scroll.

## Available constraints vs screen size

Prefer decisions based on the space actually available to the component.

Use `LayoutBuilder` when component behavior depends on parent constraints.

Use `MediaQuery` when behavior depends on screen/environment information such
as:

- view insets
- text scaling
- platform padding
- orientation
- system UI

Do not assume screen width equals available component width.

This matters in:

- dialogs
- side panels
- nested layouts
- split-screen
- desktop windows
- foldables
- embedded/hosted UI regions

## Fixed dimensions

Fixed dimensions are not automatically wrong.

They may be appropriate for:

- icons
- logos
- avatars
- thumbnails
- known touch targets
- deliberately fixed controls
- visual assets with intended aspect ratios

Report a fixed dimension only when it creates a realistic risk under supported:

- screen sizes
- text scaling
- localization
- orientation
- window resizing
- keyboard/inset changes
- parent constraints

Do not replace a valid fixed value with proportional scaling merely to make the
layout "responsive."

## Text and localization-sensitive layout

Allow for:

- longer translations
- Arabic/English length differences
- multiple lines
- increased text scale
- dynamic content

Review:

- fixed-height containers around text
- tightly constrained rows
- hardcoded line counts
- clipping/ellipsis that hides critical content
- buttons that cannot grow
- labels competing for horizontal space

Do not assume clipping exists from static code alone when actual constraints and
text are unknown.

Mark uncertain rendered behavior for visual verification.

## Breakpoints

Use a small number of meaningful layout modes.

Derive breakpoints from layout behavior, not from one device model.

Good breakpoint reasoning asks:

- when does the current composition stop working well?
- when does available space allow a materially better layout?
- when should navigation or content arrangement change?

Avoid:

- device-name checks
- dozens of arbitrary width thresholds
- breakpoints chosen only because a screenshot was taken at that width

Prefer semantic modes such as:

- compact
- medium
- expanded

when they fit the project.

Do not introduce a breakpoint system if the existing layout already adapts
cleanly without one.

## Safe areas and insets

Account for relevant environmental constraints:

- status bars
- navigation bars
- notches/cutouts
- keyboard insets
- foldable display features
- bottom gesture areas
- modal insets

Do not nest `SafeArea` mechanically.

Inspect whether parent layouts already handle system padding.

Do not add padding twice.

## Dialogs and bottom sheets

Review:

- max width on large screens
- keyboard insets
- content growth
- text scaling
- safe areas
- scrolling behavior
- action buttons remaining reachable
- nested scrollables

Do not assume a mobile-width dialog should expand to full desktop width.

Do not force fixed height just to keep content visible.

## Lists and grids

Review adaptive collections for:

- column count
- spacing
- item minimum/maximum width
- overly stretched cards
- too-dense layouts on small screens
- eager building
- nested scrolling
- aspect-ratio assumptions

Do not scale every element proportionally with screen width.

Prefer layout changes that preserve usability rather than mathematically scaling
all dimensions.

## Orientation, window resizing, and multi-window

Do not treat orientation as the only source of size change.

For supported platforms, consider:

- live desktop/web window resizing
- split-screen
- multi-window
- changing parent constraints
- keyboard appearance
- system UI changes
- foldable posture/hinge regions

Layout should respond to current constraints rather than assuming a one-time
startup size.

Do not require foldable-specific logic when the project does not target or need
it.

## Platform interaction patterns

When relevant to supported targets, consider:

- touch
- mouse/pointer
- hover
- wheel scrolling
- keyboard navigation
- shortcuts
- right-click/context actions
- TV/remote focus

Do not create separate widget trees for every platform unless behavior genuinely
differs.

Prefer adaptive composition where practical.

Do not overengineer desktop/web interaction for a mobile-only application.

## Responsive vs adaptive

Responsive behavior changes layout based on available space.

Adaptive behavior may also change interaction pattern or component choice for a
platform/form factor.

Do not force platform-specific widgets merely for visual difference.

Use adaptive behavior when it improves real usability or matches required
platform interaction semantics.

## Full-project responsive coverage

During an explicitly requested full-project production audit, systematically
consider the user-facing layout surfaces that actually exist.

Typical areas include:

- app shell/navigation
- primary feature screens
- forms
- dialogs
- bottom sheets
- lists/grids
- detail screens
- empty/error/loading states
- onboarding/authentication
- localized Arabic/English layouts
- large text
- orientation changes
- keyboard-open states
- tablet layouts
- desktop/web windows when targeted
- split-screen/multi-window when relevant

Do not claim the whole UI is responsive because a few screens were inspected.

Inspect shared layout primitives plus enough production-critical feature
screens to support the conclusion.

If coverage is incomplete, mark affected surfaces as:

- Not reviewed
- Needs verification

rather than implying complete responsive readiness.

## Evidence discipline

Classify findings as:

- **Confirmed**
- **Likely**
- **Needs verification**

Examples:

- Confirmed: `Expanded` is used in an actually unbounded axis and the code path
  establishes the constraint violation.
- Needs verification: translated text may overflow at maximum supported text
  scale on a narrow device.

- Confirmed: a dialog has an unconditional 900px width with no surrounding
  constraint on a supported 360px-wide layout.
- Likely: this will produce poor layout on small phones.

- Confirmed: a nested scrollable uses `shrinkWrap` over an unbounded large
  dataset.
- Needs verification: this creates noticeable runtime jank on supported devices.

Do not inflate severity using an unverified rendered or performance consequence.

Do not assume:

- fixed width = responsiveness bug
- `MediaQuery` = bad architecture
- `SingleChildScrollView` = correct overflow fix
- `shrinkWrap` = correct nested-scroll fix
- `Expanded` = correct Row/Column fix
- landscape = tablet
- wide screen = desktop
- orientation = available layout width

Inspect actual constraints and supported targets.

## Cargo-cult guardrails

Do not mechanically:

- wrap overflowing layouts in `SingleChildScrollView`
- add `Expanded` everywhere
- add `Flexible` everywhere
- set `shrinkWrap: true`
- replace fixed values with percentages
- introduce breakpoints everywhere
- replace every `MediaQuery` with `LayoutBuilder`
- add `SafeArea` around every screen
- create separate mobile/tablet/desktop widget trees
- scale all padding/font/icon values by screen width

Use the smallest change that fixes the verified layout problem.

## Reporting

For each finding, report:

- file/component
- supported layout/context affected
- exact constraint/adaptation issue
- evidence
- realistic trigger
- likely or verified user impact
- recommended direction
- confidence
- runtime/visual/device verification required

For full-project audits, also report:

- surfaces actually reviewed
- form factors actually considered
- surfaces requiring visual/device verification
- unsupported/unreviewed form factors

Use evidence-bounded wording.

Prefer:

- "No structural responsive-layout issue was identified in the reviewed
  screens."

over:

- "The UI is fully responsive."

Prefer:

- "The reviewed layout adapts correctly to the inspected constraints."

over:

- "Works on all screen sizes."

Do not claim:

- fully responsive
- no overflow
- tablet-ready
- desktop-ready
- foldable-ready
- works at all text scales
- works on all screen sizes

unless the evidence actually supports those claims.

## Final principle

This skill answers:

**"What layout/adaptation risks are supported by the implementation, and which
rendered behaviors still require visual or device verification?"**

It does not answer:

**"Can static inspection prove every screen works on every possible size,
orientation, locale, and device?"**