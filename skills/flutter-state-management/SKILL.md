---
name: flutter-state-management
description: Reviews and implements Flutter state management safely across Bloc, Cubit, Riverpod, Provider, ChangeNotifier, signals, setState, and similar approaches — including async event semantics, concurrency, cancellation, optimistic updates, lifecycle safety, rebuild scope, persistence/restoration, and state consistency. Use when modifying or reviewing state, async flows, subscriptions, controllers, providers, blocs, cubits, or UI state wiring. Reviewing does not imply permission to edit — respect the calling task's mode.
---

# Flutter State Management

Respect the state-management solution already used by the project.

Do not migrate, replace, or mix state-management systems without a concrete
technical reason supported by evidence.

If invoked during a read-only review, report findings only. Do not edit files.

## Understand the flow first

Before recommending or implementing a state-management change, trace enough
of the actual flow to understand its semantics.

When relevant, follow:

UI interaction → event/action → state holder → domain/business logic →
repository/service → persistence/network/platform side effect → resulting state.

Do not make decisions from an event, method, Cubit, provider, or state class
in isolation when its behavior depends on downstream work.

Determine:

- what the user action actually means
- which layer owns the source of truth
- whether the operation has side effects
- whether those side effects are idempotent
- whether ordering matters
- whether intermediate events matter
- what should happen when operations overlap
- what should happen when an operation fails
- what the UI expects while work is in progress

## State ownership

State should live at the narrowest sensible scope.

Check for:

- unnecessary global state
- duplicate sources of truth
- UI-only state stored globally
- persistent state stored only in ephemeral widgets
- the same domain data independently owned by multiple state holders
- derived state stored separately and manually synchronized
- state that survives longer than the feature that owns it
- feature state accidentally tied to a widget lifecycle when it must survive
  navigation or restoration

Do not move state upward merely because broader scope seems architecturally
cleaner.

Broaden ownership only when the required lifetime or sharing semantics
justify it.

## Concurrency semantics — determine intent before choosing a strategy

Never choose a concurrency strategy merely from the event name or because
rapid interactions exist.

Before recommending or implementing:

- `droppable`
- `restartable`
- `sequential`
- `concurrent`
- debounce
- throttle
- cancellation
- deduplication
- coalescing
- optimistic updates

determine the actual semantics of the operation.

Ask:

- Must every event be preserved?
- Does ordering matter?
- Does only the latest desired state matter?
- Are repeated events truly redundant?
- Can two different entities generate the same event type?
- Is the operation idempotent?
- Can operations safely overlap?
- Can an older result overwrite a newer result?
- Is cancellation safe?
- Have irreversible side effects already started?
- What final state does the user expect?

Do not drop user intent merely to reduce concurrency or improve performance.

### Examples of different semantics

A search-as-you-type query may legitimately care only about the latest query.

Three rapid "add item" actions may represent three distinct operations and
must not be collapsed into one.

Events for three different habits may share the same event type while
representing three independent user actions.

A checkbox or switch may represent desired-state semantics rather than
"perform one toggle" semantics.

A save, payment, delete, upload, or submission may require serialization,
deduplication, idempotency protection, or explicit in-flight guarding.

These examples are guidance, not automatic transformer rules.

Inspect the actual implementation before deciding.

## Toggle and state-setting semantics

Be especially careful with toggles, switches, checkboxes, counters, and
state-setting actions.

Determine whether the event means:

- "toggle whatever the current value is"
- "set the value to true/false"
- "increment/decrement once"
- "persist this exact desired state"
- "record a distinct occurrence"

These semantics are not interchangeable.

For rapid interactions, verify that the final persisted state matches the
user's final intent.

Do not use `droppable`, debounce, throttle, or deduplication simply because
multiple events happen quickly.

Do not assume `concurrent` is safe when operations can update the same record.

Do not assume `sequential` is always correct either; it may preserve obsolete
work that should instead be superseded.

Choose the strategy from the required behavior.

## Async safety

Review async state transitions for:

- disposed or closed owners
- stale requests
- concurrent requests
- race conditions
- results arriving out of order
- duplicate submissions
- overlapping mutations
- stale state captured before an `await`
- state emitted after ownership ended
- loading states that never clear
- errors that leave state inconsistent
- optimistic updates that are not rolled back
- retries that duplicate non-idempotent side effects
- navigation/lifecycle changes while work is running

Use lifecycle/liveness checks appropriate to the framework only where needed.

Examples include:

- Bloc/Cubit `isClosed`
- Riverpod `ref.mounted`
- Flutter `context.mounted`

Do not add defensive mounted/closed checks mechanically when they do not
address a real lifecycle boundary.

## Cancellation semantics

Cancelling a Dart-side handler does not necessarily cancel its underlying work.

For example, cancelling or superseding a state-management operation may not
automatically cancel:

- an HTTP request
- a database write or transaction
- filesystem I/O
- an upload
- a platform-channel call
- native SDK work
- isolate work
- a background task

Verify the actual cancellation mechanism before relying on cancellation for
correctness.

If underlying work cannot be cancelled, consider whether stale-result
suppression, operation IDs, version checks, serialization, idempotency, or
another project-appropriate mechanism is required.

Do not claim that an operation was cancelled unless the relevant underlying
side effect was actually cancelled or its result was safely prevented from
affecting state.

## Stale and out-of-order results

When multiple async reads or mutations can overlap, verify that an older
operation cannot overwrite newer state incorrectly.

Pay particular attention to:

- search
- refresh
- pagination
- filters
- account/session changes
- rapidly changing selections
- autosave
- network-backed forms
- database + network synchronization
- lifecycle-triggered reloads

Where latest-result semantics are required, make that requirement explicit.

Where every operation matters, preserve every operation instead.

## Optimistic updates

Use optimistic UI only when it matches the product semantics and failure can
be handled coherently.

When optimistic updates exist, check:

- what happens when persistence/network work fails
- whether rollback restores the correct previous state
- whether a later action occurred before the failure returned
- whether one failed operation can incorrectly roll back a newer successful
  operation
- whether retries duplicate the action
- whether UI state and persistent state can diverge

Do not recommend optimistic updates merely to hide slow persistence.

Fix the underlying performance problem when that is the actual issue.

## Error recovery

Check that failures leave both state and UI coherent.

Verify where relevant:

- loading clears on failure
- errors are represented rather than silently discarded
- stale successful data is not incorrectly presented as fresh
- retry behavior is safe
- partial mutations are handled
- user actions can be retried
- repeated retry does not duplicate irreversible side effects

Do not silently convert failures into empty-success states unless that is
explicitly the intended product behavior.

## State design

Check whether relevant flows represent meaningful states such as:

- initial
- loading
- success
- empty
- failure
- refreshing
- submitting

Do not require every feature to use all of these states.

Use only the states that accurately model the feature.

Ensure transitions are valid and predictable.

Avoid contradictory states such as simultaneously representing mutually
exclusive conditions unless the model intentionally supports them.

## Rebuild scope

Flutter rebuilds are normal.

Do not treat rebuilds as a problem merely because they occur.

Look for meaningful cases such as:

- a broad state subscription rebuilding a large subtree for a tiny change
- expensive transformations repeated on every state update
- multiple consumers independently performing the same computation
- state objects changing identity unnecessarily
- selectors that cannot filter effectively because equality is incorrect
- high-frequency state updates rebuilding unrelated UI

Subscribe to the narrowest state that makes sense.

Use the project's existing selectors, scoped consumers, builders, or equivalent
mechanisms when they provide meaningful benefit.

Do not add selectors or split state mechanically without evidence.

## Equality and state identity

Where the project's state-management approach relies on equality or immutable
state, verify that equality semantics match the intended behavior.

Check for:

- fields missing from equality
- mutable collections inside otherwise immutable state
- in-place mutation preventing listeners from detecting changes
- unnecessary new state objects causing avoidable updates
- copied state accidentally retaining stale fields

Follow the project's existing model/equality conventions rather than
introducing a new approach without need.

## Streams, subscriptions, listeners, and controllers

Check ownership and lifecycle of:

- StreamSubscription
- ChangeNotifier listeners
- ValueNotifier listeners
- controllers
- provider subscriptions
- Bloc/Cubit subscriptions
- timers associated with state
- event buses or similar mechanisms

Only dispose/cancel resources owned by that state holder.

Do not dispose resources borrowed from a parent, DI container, provider, or
another owner.

Check for duplicate subscriptions after rebuild/reinitialization and for
listeners that remain active after their feature is gone.

## Persistence and restoration

When state interacts with persistence, verify:

- which layer is the source of truth
- whether UI state can diverge from persisted state
- whether writes complete before dependent operations occur
- how failures are represented
- whether restored state can be stale
- process-death behavior where relevant
- whether temporary UI state is incorrectly persisted
- whether persistent domain state is incorrectly lost with widget disposal

Do not assume state persistence is required for every state holder.

## UI separation

State holders should not depend unnecessarily on `BuildContext`, widgets, or
presentation-only concepts.

Business logic should not become tightly coupled to UI presentation.

However, do not create abstractions merely to remove every reference to
presentation concepts if the existing project intentionally uses a simpler
pattern and it causes no concrete problem.

## Events and commands

Review destructive, expensive, irreversible, or externally visible actions
carefully.

Examples:

- checkout
- payment
- submit
- upload
- login
- refresh
- save
- delete
- sync

Determine whether they need:

- in-flight protection
- idempotency
- serialization
- retry protection
- confirmation
- deduplication

Do not automatically debounce or drop repeated commands.

## Existing stack

Learn the project's current conventions before implementing changes.

Match the existing:

- state classes
- naming
- event/action structure
- dependency injection
- error representation
- loading conventions
- immutable/equality conventions
- repository boundaries
- test conventions

Do not introduce a competing state-management pattern inside an existing
feature without a concrete technical reason.

## Cargo-cult guardrails

Do not recommend a state-management technique merely because it is commonly
associated with a particular problem.

In particular:

- do not add `droppable` merely because events can happen rapidly
- do not add `restartable` merely because only one handler should appear active
- do not add `sequential` merely because database writes exist
- do not add `concurrent` merely to improve responsiveness
- do not debounce or throttle user intent without verifying that discarded
  intermediate actions are semantically irrelevant
- do not add optimistic updates merely to hide latency
- do not globalize state merely to make it survive one widget
- do not add selectors merely because rebuilds occur
- do not add mounted/closed checks mechanically
- do not persist state merely because restoration is possible
- do not replace the project's existing state-management solution because
  another approach appears cleaner or more modern

Every recommendation must follow from the actual semantics and evidence of the
reviewed flow.

## Full-project state-management coverage

During an explicitly requested full-project production audit, do not limit
state-management review to already-suspected blocs, cubits, providers,
controllers, or individual features.

Systematically consider the stateful production flows that actually exist in
the project, including when applicable:

- application/session state
- feature-local state
- authentication/session changes
- form state and submission flows
- loading/error/empty transitions
- persistence-backed state
- restoration after restart/process death
- navigation-triggered state changes
- background/foreground transitions
- timers/subscriptions/listeners
- synchronization
- refresh/reload flows
- optimistic updates
- high-frequency interactions
- destructive or irreversible commands
- cross-feature/shared state
- async operations that can overlap

Do not claim state-management coverage from inspecting only one representative
Bloc, Cubit, provider, controller, or feature when materially different state
patterns exist elsewhere.

Use search and architectural tracing to identify production-critical state
flows before opening large numbers of files.

For each materially different pattern, inspect enough representative entry
points and downstream side effects to support the conclusion.

Efficiency must not override required full-project coverage.

If repository size, tooling, context limits, unavailable runtime behavior, or
other constraints prevent adequate review, mark the affected area as:

- Not reviewed
- Needs verification

rather than implying complete state-management readiness.

A full-project static state-management audit still does not prove every
possible runtime interleaving, lifecycle transition, or platform interaction.

## Evidence discipline

Do not report a state-management problem merely because another pattern could
also work.

The absence of Bloc, Riverpod, Provider, selectors, immutable generators,
event transformers, or any specific state-management technique is not a
finding by itself.

Report an issue only when the existing behavior creates a realistic
correctness, lifecycle, concurrency, performance, UX, or maintainability risk.

For concurrency findings, establish when relevant:

- the actual event/action semantics
- whether every event matters or latest-state semantics apply
- the side effect being performed
- whether the side effect is idempotent
- whether ordering matters
- whether operations can safely overlap
- whether cancellation is real or only Dart-side
- whether an older result can overwrite newer state
- the realistic failure scenario
- why the proposed strategy preserves user intent

If any of these cannot be established from static inspection, state what needs
verification instead of guessing.

Separate the primary structural observation from any runtime consequence.

For example:

- "This event uses `droppable()` and therefore later same-type events arriving
  during the active handler are discarded" may be statically Confirmed.
- "Users lose data because of this" requires evidence that those discarded
  events represent required user intent and that no other layer restores or
  persists the intended state.

Likewise:

- "Two async requests can complete out of order" may be Confirmed from the
  implementation.
- "Users frequently see stale data" may still require runtime evidence.

Do not use an unverified consequence to inflate severity.

## Confidence classification

Classify each finding as exactly one of:

- **Confirmed** — the actual state/event flow was traced far enough to verify
  that the problem exists as described.
- **Likely** — strong evidence supports the issue, but an important part of the
  flow, side effect, environment, or behavior could not be fully verified.
- **Needs verification** — runtime behavior, timing, device/platform behavior,
  additional tracing, profiling, or other evidence is required to establish
  the claim.

Examples:

**Confirmed**

`droppable()` is used for an event type where traced callers show that multiple
distinct same-type user actions must all be preserved, and the handler's
side effects demonstrate that discarded events are not recovered elsewhere.

**Needs verification**

The resulting dropped interactions cause noticeable user frustration or a
measurable conversion/engagement impact.

**Confirmed**

An older async request can complete after a newer request and overwrite the
newer state because no ordering/version/stale-result protection exists.

**Likely**

The race is reachable under realistic network timing, but its frequency in
production is unknown.

**Confirmed**

Cancelling or superseding the Dart-side handler does not cancel the traced
underlying operation.

**Needs verification**

The surviving underlying operation causes duplicate external side effects in
the real runtime environment.

Confidence and severity are separate.

A Confirmed issue may be LOW severity.

A Needs verification consequence must not be used to justify CRITICAL or HIGH
severity unless the high-impact behavior itself has sufficient evidence.

## Reporting

For each state-management finding, report:

- file/component
- affected state flow
- actual user/action semantics
- source of truth
- relevant side effects
- ordering/concurrency behavior
- whether every event matters or latest-state semantics apply
- whether cancellation is real or only Dart-side when relevant
- realistic trigger
- evidence-supported impact
- recommended direction
- confidence
- required runtime/device verification, if any

Do not require irrelevant fields merely to satisfy the reporting template.

For a full-project audit, also state:

- which major state-management flows were reviewed
- which materially different state-management patterns exist
- which flows or patterns were not reviewed
- which conclusions still require runtime/device verification

Do not claim:

- "no race conditions"
- "state management is fully safe"
- "all async flows are correct"
- "no stale state is possible"
- "all state is correctly persisted"
- "all lifecycle cases are handled"

unless the available evidence truly supports those absolute claims.

Prefer evidence-bounded wording such as:

- "No meaningful state-consistency issue was identified in the reviewed flow."
- "No ordering defect was found in the traced handlers."
- "The reviewed persistence flow preserves the expected source-of-truth
  semantics."
- "Runtime timing behavior still requires verification."

Do not turn absence of an identified issue into proof that no issue exists.

## Final principle

This skill answers:

**Do the reviewed state flows preserve user intent, ordering, consistency,
lifecycle safety, ownership, and side-effect semantics under realistic async
behavior?**

It does not answer:

**Can static inspection prove every possible state transition, race condition,
runtime interleaving, lifecycle transition, or platform interaction is correct?**

Choose state-management behavior from product semantics and traced side effects,
not from framework folklore or transformer names.

Preserve user intent first. Optimize concurrency second.