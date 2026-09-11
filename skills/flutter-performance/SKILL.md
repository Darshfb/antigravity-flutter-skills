---
name: flutter-performance
description: Detects meaningful Flutter performance and memory problems — unnecessary rebuilds, expensive build work, inefficient lists, resource leaks, excessive I/O, startup work, image handling, caching, unbounded memory growth, peak-memory risks, and recurring/background work. Use for performance audits, jank, slow screens, high memory usage, OOM concerns, rebuild concerns, or full-project reviews. Reviewing does not imply permission to edit — respect the calling task's mode.
---

# Flutter Performance

Focus on meaningful performance problems supported by evidence.

Do not optimize for theoretical cleanliness or micro-benchmarks that have no realistic user impact.

If invoked during a read-only review, report findings only. Do not edit files.

## Core performance principle

Separate:

- structural performance risks visible from static inspection
- likely runtime risks
- measured runtime performance

Static code can confirm some deterministic problems, but many performance claims require profiling.

Do not claim:

- measurable jank
- dropped frames
- startup slowdown
- excessive memory usage
- OOM
- battery drain
- smoothness
- fast startup
- safe memory usage

from static inspection alone unless the cause is deterministic and clearly sufficient to support that conclusion.

When runtime impact depends on:

- dataset size
- device capability
- frame frequency
- user behavior
- cache state
- lifecycle behavior
- platform scheduling
- OS background policy

classify the concern as **Likely** or **Needs verification** and state what should be measured.

## Rebuilds

Flutter widgets are expected to rebuild.

A rebuild is not a performance problem by itself.

Look for meaningful cases such as:

- overly broad state subscriptions
- large subtrees rebuilding for small state changes
- expensive computation repeated during build
- repeated parsing/transformation in build paths
- high-frequency state changes rebuilding unrelated UI
- inherited dependencies scoped more broadly than necessary
- selectors that fail to narrow updates because equality/identity is incorrect

Flag rebuild behavior only when the amount, frequency, or cost is realistically significant.

Do not recommend splitting widgets or adding selectors mechanically.

## Build methods

Avoid heavy or side-effecting work in build paths.

Inspect for:

- database reads
- network calls
- filesystem I/O
- expensive parsing
- large sorting/filtering
- repeated serialization
- synchronous CPU-heavy loops
- work that allocates large temporary object graphs

Do not classify small deterministic transformations as performance bugs merely because they occur in `build()`.

Consider frequency and cost.

## Memory and data volume

Inspect:

- full-table reads
- very large result sets
- large JSON/object graphs
- whole-file loading
- unbounded collections
- unbounded caches
- retained serialized copies alongside deserialized data
- multiple simultaneous representations of the same dataset
- accumulated batches
- checksum/index lists
- long-lived closures/listeners retaining large objects
- static/singleton state that grows over time
- large in-memory backup/sync/import/export pipelines

Do not call something an OOM risk merely because it loads many records.

Reason about:

- realistic dataset size
- peak memory, not just total processed bytes
- object lifetime
- whether multiple copies coexist
- whether memory is released between chunks
- how often the flow runs
- target device class
- whether the structure grows with total user history

A confirmed full-table read may be a confirmed structural characteristic without being a confirmed memory failure.

Keep those claims separate.

## Chunking, batching, pagination, and streaming

When recommending chunking, batching, pagination, or streaming, verify that the proposed change actually bounds **peak memory**.

Do not accept a solution that:

- reads all data first and chunks afterward
- keeps a global checksum list that still grows O(n)
- retains previous chunks unnecessarily
- duplicates the full dataset in another structure
- introduces an unbounded cache while claiming memory improvement

Check the entire pipeline, not only the database read.

## Lists and grids

Review large or dynamic lists/grids for:

- eager child construction
- expensive item widgets
- repeated per-item transformation
- unstable identity when identity matters
- expensive layout patterns
- unnecessary image decoding
- nested scrolling patterns that increase work significantly
- pagination/loading logic that retains too much history

Prefer lazy builders when appropriate.

Do not demand lazy construction for small bounded collections where it provides no meaningful benefit.

## Images and media

Check for:

- unnecessarily large decoded images relative to display size
- repeated image downloads
- missing caching where repeated fetching materially matters
- unbounded image caches
- large bundled assets
- repeated transformations or resizing
- holding full-resolution image bytes longer than necessary

Distinguish:

- network transfer size
- decoded memory size
- disk cache
- in-memory cache

Do not treat them as the same thing.

## Resources

Check ownership and cleanup of performance-relevant resources such as:

- `AnimationController`
- `TextEditingController`
- `ScrollController`
- `FocusNode`
- `StreamSubscription`
- `Timer`
- listeners
- isolates
- native resources
- long-lived callbacks

Only flag missing cleanup when the object actually owns the resource.

Do not recommend disposing something borrowed from a parent, provider, DI container, or another lifecycle owner.

## Recurring and background work

Review when relevant:

- timers
- polling loops
- subscriptions
- lifecycle-triggered refreshes
- duplicate sync loops
- repeated startup tasks
- background jobs
- repeated database/network reconciliation
- observers that remain active after navigation
- periodic work with no stop condition
- multiple features scheduling equivalent work

Check:

- frequency
- duplication
- cancellation
- lifecycle ownership
- work performed while app state changes
- whether refreshes overlap
- whether work continues unnecessarily

Do not assume background work is expensive merely because it repeats.

Estimate or profile frequency and cost.

## Main-isolate CPU work

Look for CPU-heavy synchronous work on the main isolate, such as:

- large JSON parsing
- compression/decompression
- encryption
- large transformations
- expensive search/sort over large datasets
- image processing
- large report generation

Recommend `compute`/isolates only when the workload is large enough to justify transfer/setup overhead.

Do not offload trivial work mechanically.

## Networking

Check for:

- duplicate in-flight requests
- repeated identical fetches in short intervals
- polling more frequently than needed
- unnecessary retries
- duplicated serialization
- responses retained longer than necessary
- requests triggered repeatedly by rebuild/lifecycle events

Do not recommend caching automatically.

Caching has correctness and invalidation costs.

Use it when repeated work is meaningful and cache semantics are clear.

## Persistence

Inspect:

- repeated database reads for unchanged data
- unnecessary writes
- write amplification
- repeated transactions
- full-table reads where bounded queries would be sufficient
- expensive joins or transformations in hot paths
- database work triggered by rebuilds or high-frequency events
- synchronization logic that reprocesses unchanged data

Distinguish slow query concerns from memory concerns.

A large read may be memory-heavy without being database-slow, and vice versa.

## Caching

Check caches for:

- missing bounds
- stale invalidation
- duplicate representations
- unnecessary persistence
- caches keyed too broadly
- data that can never be evicted
- caches that grow with total account history

Do not call absence of caching a performance defect unless repeated work is actually meaningful.

Do not call presence of caching an optimization if invalidation or memory growth creates a larger problem.

## Startup

Review startup for:

- blocking initialization
- unnecessary eager services
- database migrations
- synchronous parsing
- network calls required before first frame
- duplicate initialization
- work that could safely be deferred

Separate:

- required correctness-critical initialization
- work needed before first usable screen
- work that can happen later

Do not recommend deferring initialization when doing so would create races or incorrect state.

## RepaintBoundary, const, keys, and isolates

Do not recommend these mechanically.

Use:

- `const` when natural and beneficial
- keys when identity matters
- `RepaintBoundary` when repaint isolation has a justified measurable reason
- isolates when CPU workload is meaningfully large

Do not cargo-cult Flutter performance APIs.

Their presence is not proof of good performance, and their absence is not proof of a performance problem.

## Full-project production-readiness coverage

During an explicitly requested full-project production audit, do not limit performance review to obvious hotspots.

Systematically consider material performance surfaces that actually exist in the project, including when applicable:

- startup and initialization
- high-frequency state updates
- rebuild scope
- large/dynamic lists and grids
- build-path computation
- images/media
- persistence
- networking
- serialization/parsing
- caching
- memory/data volume
- sync/backup/import/export
- timers/polling/subscriptions
- background work
- long-lived resources
- lifecycle-triggered repeated work
- main-isolate CPU-heavy work
- growth over long-lived user accounts

Do not claim a surface was reviewed merely because one related file was inspected.

Inspect enough of the relevant flow to support the conclusion.

If coverage is limited by repository size, unavailable runtime data, device constraints, or tooling, mark the area as:

- Needs verification
- Not reviewed

rather than quietly implying performance readiness.

## Profiling guidance

Use profiling when the question depends on runtime behavior.

Useful validation may include:

- Flutter DevTools frame analysis
- memory/heap profiling
- allocation tracking
- startup timing
- seeded large-dataset tests
- long-running resource observation
- background/foreground stress testing
- low-end device testing
- network throttling
- repeated navigation/session stress tests

Do not require profiling for deterministic static issues that are already evident.

Do not claim profiling results unless profiling was actually performed.

## Evidence discipline

For every performance finding, distinguish:

- **Confirmed** — the structural issue or deterministic runtime cost is established by inspected evidence
- **Likely** — strong evidence suggests runtime impact, but actual magnitude was not measured
- **Needs verification** — runtime/profiling/device evidence is required before the claim can be established

Keep the primary observation separate from the runtime consequence.

Examples:

- Confirmed: a query loads the entire table.
- Needs verification: this causes unacceptable memory pressure on supported devices.

- Confirmed: a large synchronous parse happens on the main isolate.
- Likely: it may cause visible frame delay at realistic payload sizes.

- Confirmed: a cache has no eviction policy.
- Needs verification: real user data causes excessive memory growth.

Do not inflate severity based on an unverified consequence.

## Reporting

For each finding, report:

- file/component
- performance behavior
- supporting evidence
- when it occurs
- realistic workload/data conditions
- likely or verified user impact
- recommended direction
- confidence
- runtime/profile validation required

For full-project audits, also report which material performance surfaces were actually reviewed and which still require profiling.

Use evidence-bounded language.

Prefer:

- "Static inspection found no clear structural performance issue in the reviewed flow."

over:

- "Performance is good."

Prefer:

- "No material memory-growth risk was identified in the reviewed implementation."

over:

- "Memory is safe."

Do not claim:

- no jank
- smooth performance
- safe memory usage
- fast startup
- no leaks
- no OOM risk

solely because static inspection found no obvious issue.

## Final principle

The skill answers:

**"What performance risks are supported by the code and evidence, and which runtime characteristics still require measurement?"**

It does not answer:

**"Can static inspection prove this app is fast on every supported device?"**