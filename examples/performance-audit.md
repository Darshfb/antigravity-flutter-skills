# Flutter Performance Audit

Use this prompt to investigate performance, memory, startup, rebuild, resource,
or data-volume concerns without making changes.

## Prompt

Perform a focused performance audit of this Flutter application.

Primary concern, if known:

[Describe the performance concern, or write "General performance review"]

Explicitly load and follow `flutter-production-audit`.

Explicitly load and follow `flutter-performance`.

Use other relevant specialist and official Dart/Flutter skills only when the
traced execution paths require them.

This is Audit Mode.

Do not modify project files or implement optimizations.

Inspect the relevant performance surfaces that actually exist, including where
applicable:

- startup and initialization
- rebuild scope and high-frequency state updates
- expensive build-path work
- large or dynamic lists/grids
- images and decoded image memory
- networking and duplicate requests
- persistence and database access
- serialization, parsing, sorting, and transformation
- caching and cache growth
- large in-memory collections
- timers, polling, subscriptions, and background work
- controller/listener/resource lifetime
- CPU-heavy main-isolate work
- lifecycle-triggered repeated work

Reason about realistic workload and peak memory rather than flagging code merely
because it processes many records or rebuilds widgets.

Apply the confidence model strictly:

- Confirmed
- Likely
- Needs verification

Do not claim measurable jank, frame drops, startup slowdown, memory pressure, or
OOM behavior from static inspection unless the evidence establishes it.

Report:

- reviewed performance surfaces
- confirmed structural performance problems
- likely performance risks
- profiling candidates
- affected execution paths
- likely user impact
- recommended changes
- prioritized implementation plan
- exact runtime profiling still required

Stop before implementation.