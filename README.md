# Antigravity Flutter Skills

A production-focused Flutter skill set for Antigravity, designed to improve full-project audits, implementation safety, codebase consistency, state-management reasoning, performance analysis, responsive UI, accessibility/RTL review, and post-implementation validation.

The system is built around a simple principle:

> **Understand first. Verify with evidence. Change only with authorization. Validate before claiming success.**

These skills are intentionally architecture-neutral. They do not force Bloc, Riverpod, Provider, `go_router`, Dio, a particular database, dependency-injection framework, or project structure.

They work with the architecture already present in the Flutter project and report problems only when there is concrete evidence of a correctness, reliability, performance, accessibility, maintainability, or production-readiness risk.

---

## Skills

The repository contains seven complementary Flutter skills.

| Skill                          | Purpose                                                                                                                                                   |
| ------------------------------ | --------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `flutter-production-audit`     | Orchestrates comprehensive production-readiness audits across the Flutter project                                                                         |
| `flutter-state-management`     | Reviews async state flows, concurrency semantics, cancellation, lifecycle safety, state ownership, persistence, and rebuild scope                         |
| `flutter-performance`          | Reviews meaningful performance and memory risks including rebuilds, I/O, startup, images, caching, large datasets, background work, and resource lifetime |
| `flutter-codebase-conventions` | Keeps changes consistent with the existing project and detects meaningful duplication or convention drift                                                 |
| `flutter-responsive`           | Reviews Flutter constraints, adaptive layouts, overflow risks, breakpoints, safe areas, large text, orientation, and multi-window behavior                |
| `flutter-a11y-rtl`             | Reviews accessibility, semantics, RTL/LTR behavior, touch targets, text scaling, forms, focus, and localization-sensitive UI                              |
| `flutter-review-gate`          | Performs the final post-implementation validation before an implementation can be considered complete                                                     |

---

## How the System Works

The skills are designed to work together rather than as isolated checklists.

```text
                    ┌──────────────────────────┐
                    │ flutter-production-audit │
                    │       Orchestrator       │
                    └────────────┬─────────────┘
                                 │
                  ┌──────────────┼──────────────┐
                  │              │              │
                  ▼              ▼              ▼
          State Management   Performance     Codebase
             Specialist       Specialist    Conventions
                  │              │              │
                  └──────┬───────┴──────┬───────┘
                         │              │
                         ▼              ▼
                    Responsive      A11y / RTL
                         │              │
                         └──────┬───────┘
                                │
                                ▼
                        Explicit Approval
                                │
                                ▼
                         Implementation
                                │
                                ▼
                    ┌─────────────────────┐
                    │ flutter-review-gate │
                    │  Final Validation   │
                    └─────────────────────┘
```

`flutter-production-audit` determines what needs to be investigated and routes relevant areas to specialist skills.

The specialist skills provide domain-specific reasoning.

After an approved implementation is complete, `flutter-review-gate` performs the final validation.

---

## Safety Model

The workflow deliberately separates auditing from implementation.

```text
UNDERSTAND
    ↓
TRACE
    ↓
VERIFY
    ↓
CLASSIFY
    ↓
PLAN
    ↓
EXPLICIT APPROVAL
    ↓
IMPLEMENT
    ↓
VALIDATE
```

A production audit does **not** automatically authorize code changes.

The default workflow is:

```text
Audit
  ↓
Findings
  ↓
Implementation Plan
  ↓
Explicit Approval
  ↓
Implementation
  ↓
Review Gate
```

### A plan is not approval

Generating an implementation plan does not authorize the agent to execute it.

Discussion, acknowledgement, or responses such as:

```text
Looks good.
Makes sense.
Thanks.
OK.
```

do not by themselves authorize implementation.

Implementation requires an explicit instruction such as:

```text
Implement the approved plan.
```

or an unambiguous confirmation to a direct implementation question.

This boundary is intentionally enforced to prevent audit findings from silently turning into unauthorized code changes.

---

## Evidence-Driven Reviews

The skills distinguish confidence from severity.

### Confidence

Findings are classified as:

* **Confirmed** — the relevant execution path was traced and the problem was verified from available evidence.
* **Likely** — strong evidence exists, but part of the behavior could not be fully verified.
* **Needs verification** — static evidence is insufficient and runtime, device, profiling, platform, or additional investigation is required.

### Severity

Confirmed or likely findings may separately be classified as:

* 🔴 **CRITICAL**
* 🟠 **HIGH**
* 🟡 **MEDIUM**
* 🔵 **LOW**
* ⚪ **NEEDS VERIFICATION**
* 🟢 **OK**

Severity and confidence are intentionally independent.

For example:

```text
🟠 HIGH | Confirmed
🟡 MEDIUM | Likely
🔵 LOW | Confirmed
⚪ NEEDS VERIFICATION
```

A potentially serious consequence is not automatically treated as confirmed simply because the underlying code looks suspicious.

---

## Production-Readiness Discipline

The audit system avoids unconditional production-readiness claims when the available evidence does not justify them.

Possible conclusions include:

* **Production ready based on reviewed and validated scope**
* **Production ready pending specified runtime/device verification**
* **Conditionally ready**
* **Not production ready yet**
* **Insufficient coverage to determine**

A clean static analysis result alone does not establish production readiness.

Passing tests alone do not establish production readiness either.

Runtime behavior such as notifications, background execution, process restoration, platform-specific lifecycle behavior, actual device performance, and release-only behavior may still require physical-device or release-build verification.

---

## Test and Coverage Discipline

The skills distinguish between:

```text
Tests passing
Code coverage
Behavioral coverage
Runtime/device validation
```

These are different forms of evidence.

Passing tests do **not** mean:

```text
100% covered
fully covered
all paths verified
no bugs remain
```

Percentage-based coverage claims require actual measured coverage data such as LCOV or an equivalent report.

Without measured coverage data, the system uses qualitative descriptions such as:

* Strong automated coverage observed
* Relevant flows have automated tests
* Partial automated coverage
* Important path appears untested
* Coverage percentage not measured

---

## Architecture Neutrality

The skills do not treat the absence of a particular technology as a defect.

For example, the following are not findings by themselves:

```text
Navigator instead of go_router
Provider instead of Bloc
Bloc instead of Riverpod
get_it instead of another DI framework
http instead of Dio
manual serialization instead of code generation
feature-first instead of layer-first organization
```

Architecture changes are recommended only when the existing implementation creates a concrete technical problem.

The goal is to improve the project — not rewrite it according to personal preference.

---

## Anti-Cargo-Cult Review Philosophy

The specialist skills deliberately avoid mechanical Flutter advice.

The system does not automatically recommend:

* `const` everywhere
* `RepaintBoundary` everywhere
* selectors everywhere
* `SingleChildScrollView` for every overflow
* `shrinkWrap: true` for every nested list
* `Expanded` for every `Row` or `Column` issue
* `Semantics` around every widget
* replacing every `left/right` value with `start/end`
* mirroring every icon for RTL
* caching every request
* moving every expensive-looking operation to an isolate
* converting every repeated implementation into a shared abstraction
* applying `droppable`, `restartable`, `sequential`, or `concurrent` based only on an event name

Recommendations must follow the actual semantics and execution path of the project.

---

## State-Management Reasoning

The state-management skill supports common Flutter approaches including:

* Bloc
* Cubit
* Riverpod
* Provider
* ChangeNotifier
* signals
* `setState`
* similar state-management approaches

It specifically reasons about asynchronous semantics such as:

```text
droppable
restartable
sequential
concurrent
debounce
throttle
deduplication
cancellation
optimistic updates
```

Concurrency strategies are selected based on user intent and side effects rather than pattern matching.

For example:

```text
Search query:
Only the latest request may matter.

Add item:
Every action may matter.

Toggle:
The final desired state may matter.

Payment:
Duplicate execution may be unacceptable.
```

A central principle is:

> **Preserve user intent first. Optimize concurrency second.**

---

## Performance Philosophy

The performance skill focuses on meaningful risks rather than micro-optimizations.

It reviews areas such as:

* rebuild scope
* expensive build-path work
* startup initialization
* database access
* networking
* large datasets
* serialization and parsing
* image decoding and caching
* background work
* timers and subscriptions
* resource ownership
* long-lived memory
* unbounded collections
* peak-memory behavior

Static inspection does not automatically prove:

```text
jank
frame drops
OOM
slow startup
high memory usage
good performance
```

When actual impact depends on runtime conditions, the result is marked as requiring profiling or device verification.

---

## Responsive and Adaptive UI

The responsive skill reasons using Flutter's actual constraint system.

It distinguishes between:

* bounded and unbounded constraints
* genuine small-screen overflow
* nested-scroll constraint problems
* incorrect `Expanded` / `Flexible` usage
* fixed dimensions that are intentional vs. accidental
* responsive vs. adaptive behavior
* phone, tablet, desktop, web, foldable, split-screen, and live window resizing

The system does not treat a fixed width or height as a bug merely because it exists.

The surrounding constraints and intended design determine whether it is problematic.

---

## Accessibility, RTL, and Localization

The accessibility and RTL skill reviews:

* Directionality
* RTL/LTR layout behavior
* directional icons
* semantics
* screen-reader usability
* text scaling
* touch targets
* forms
* focus behavior
* dialogs and modals
* dynamic announcements
* bidirectional text
* localization-sensitive layouts
* translated text expansion

It avoids mechanical rules such as mirroring every icon or wrapping every widget in `Semantics`.

Built-in Flutter semantics and platform behavior are taken into account before reporting issues.

---

## Codebase Consistency

The codebase-conventions skill follows:

> **Reuse before create — but do not force reuse.**

Before introducing new widgets, services, helpers, repositories, validators, formatters, or utilities, the project is searched for existing functionality serving the same responsibility.

However, visual similarity or repeated lines alone are not enough to justify abstraction.

The skill distinguishes between:

```text
Reuse
Extend
Create focused implementation
Intentional duplication
Migration/compatibility state
```

Correctness and clear responsibility boundaries take priority over achieving maximum DRYness.

---

## Review Gate

`flutter-review-gate` runs only after explicitly authorized implementation has been completed.

It reviews:

1. Scope
2. Correctness
3. Codebase consistency
4. UI when applicable
5. Performance/resources when applicable
6. Formatting
7. Static analysis
8. Tests and runtime-verification boundaries
9. Final validation status

The review gate does not treat:

```text
flutter analyze passes
+
flutter test passes
```

as automatic proof that the implementation is fully validated.

The final result is classified as:

* **Validated**
* **Partially validated**
* **Not validated**

according to the evidence actually obtained.

---

# Installation

## Clone the Repository

```bash
git clone https://github.com/Darshfb/antigravity-flutter-skills.git
cd antigravity-flutter-skills
```

The repository provides native installation and verification scripts for:

* macOS
* Linux
* Windows PowerShell

---

## macOS / Linux

### Verify the Repository

Before installation, you can verify the repository structure, skill metadata, examples, and shell scripts:

```bash
chmod +x verify.sh
./verify.sh
```

A successful verification ends with:

```text
Verification PASSED

Errors:   0
Warnings: 0
```

The installer also performs repository verification automatically before installation.

### Global Installation

Use global installation when you want the skills available across Antigravity projects.

```bash
chmod +x install.sh
./install.sh --global
```

The skills are installed under:

```text
~/.gemini/config/skills/
```

### Project Installation

Use project installation when you want the skills available only inside a specific project.

For the current directory:

```bash
./install.sh --project .
```

Or specify a Flutter project:

```bash
./install.sh --project /path/to/flutter/project
```

The skills are installed under:

```text
<project>/.agents/skills/
```

### Uninstall

Global installation:

```bash
chmod +x uninstall.sh
./uninstall.sh --global
```

Project installation:

```bash
./uninstall.sh --project /path/to/flutter/project
```

---

## Windows

Windows users can use the PowerShell scripts included in the repository.

### Verify the Repository

From PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File .\verify.ps1
```

A successful verification ends with:

```text
Verification PASSED

Errors:   0
Warnings: 0
```

### Global Installation

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 --global
```

The skills are installed under the current Windows user's profile:

```text
%USERPROFILE%\.gemini\config\skills\
```

In PowerShell, the equivalent location is based on:

```powershell
$HOME\.gemini\config\skills
```

### Project Installation

For the current project:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 --project .
```

Or specify another Flutter project:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 --project C:\Projects\my_flutter_app
```

The skills are installed under:

```text
<project>\.agents\skills\
```

### Uninstall

Global installation:

```powershell
powershell -ExecutionPolicy Bypass -File .\uninstall.ps1 --global
```

Project installation:

```powershell
powershell -ExecutionPolicy Bypass -File .\uninstall.ps1 --project .
```

---

## Installation Behavior

The installers manage only the seven skills contained in this repository.

They do not intentionally remove unrelated skills.

Global installation uses:

```text
~/.gemini/config/skills/
```

on macOS/Linux and the equivalent user-profile location on Windows.

Project installation uses:

```text
.agents/skills/
```

inside the selected project.

### Existing installations

When reinstalling a managed skill, the installer replaces that skill's existing destination copy with the version contained in this repository.

Unrelated skills remain untouched.

### Legacy Antigravity skill location

Older copies may exist under:

```text
~/.gemini/antigravity/skills/
```

or the equivalent Windows user-profile path.

If managed skill directories are found there, the installer may warn that Antigravity could discover a different copy than the newly installed version.

The installer does **not** automatically delete legacy copies.

Remove them manually only after confirming they are no longer required.

### Restart after installation

After installation, restart Antigravity or start a new conversation/session so the updated skills are discovered.

---

# Usage

The repository includes ready-to-use prompts under:

```text
examples/
```

## Full Project Audit

Use:

```text
examples/full-project-audit.md
```

when you want a comprehensive, read-only production-readiness audit.

The audit should inspect the project systematically, use relevant specialist skills, report evidence-backed findings, identify areas requiring runtime verification, and stop before implementation.

---

## Implement an Approved Audit Plan

Use:

```text
examples/implement-approved-audit-plan.md
```

only after an audit has already been completed and you have explicitly approved its implementation plan.

This enters Implementation Mode for the approved scope and requires `flutter-review-gate` after implementation.

---

# Recommended Workflow

A typical production-readiness workflow is:

### 1. Verify the skill repository

macOS/Linux:

```bash
./verify.sh
```

Windows:

```powershell
powershell -ExecutionPolicy Bypass -File .\verify.ps1
```

### 2. Install the skills

Install globally or into the Flutter project you want to review.

### 3. Run the audit

Use:

```text
examples/full-project-audit.md
```

Antigravity reviews the project without modifying it.

### 4. Review the findings

Check:

* Critical and High findings
* Medium findings
* Needs-verification items
* proposed implementation plan
* production-readiness verdict

### 5. Approve the implementation

After reviewing the plan, explicitly authorize it.

For example:

```text
Implement the approved production-audit plan.
```

### 6. Implement

Use:

```text
examples/implement-approved-audit-plan.md
```

The implementation remains limited to the authorized scope.

### 7. Validate

After implementation, `flutter-review-gate` performs final validation.

### 8. Complete runtime verification

Some behavior may still require:

* Android physical-device testing
* iOS physical-device testing
* background/foreground testing
* process-death testing
* notification verification
* permission-denial testing
* release-build testing
* profiling with Flutter DevTools
* store-specific validation

The review report should identify these explicitly rather than pretending they were automatically verified.

---

# Repository Structure

```text
antigravity-flutter-skills/
├── README.md
├── LICENSE
│
├── install.sh
├── uninstall.sh
├── verify.sh
│
├── install.ps1
├── uninstall.ps1
├── verify.ps1
│
├── examples/
│   ├── full-project-audit.md
│   └── implement-approved-audit-plan.md
│
└── skills/
    ├── flutter-production-audit/
    │   └── SKILL.md
    │
    ├── flutter-state-management/
    │   └── SKILL.md
    │
    ├── flutter-performance/
    │   └── SKILL.md
    │
    ├── flutter-codebase-conventions/
    │   └── SKILL.md
    │
    ├── flutter-responsive/
    │   └── SKILL.md
    │
    ├── flutter-a11y-rtl/
    │   └── SKILL.md
    │
    └── flutter-review-gate/
        └── SKILL.md
```

---

# Platform Support

| Platform | Verify       | Install       | Uninstall       |
| -------- | ------------ | ------------- | --------------- |
| macOS    | `verify.sh`  | `install.sh`  | `uninstall.sh`  |
| Linux    | `verify.sh`  | `install.sh`  | `uninstall.sh`  |
| Windows  | `verify.ps1` | `install.ps1` | `uninstall.ps1` |

Both global and project-scoped installation modes are supported.

---

# Design Goals

This repository is designed around several principles.

### Evidence over assumptions

Report what the code supports, not what merely sounds plausible.

### Correctness over style

Do not turn architectural or stylistic preferences into production findings.

### User intent over concurrency convenience

Do not drop, cancel, serialize, or merge user actions without understanding their semantics.

### Performance evidence over folklore

Do not recommend Flutter performance techniques mechanically.

### Semantic reuse over superficial DRYness

Reuse existing functionality when responsibilities genuinely match.

### Accessibility over checklist compliance

Review actual user accessibility rather than counting `Semantics` widgets.

### Constraints over screenshots

Responsive decisions should follow available layout constraints, not one device size.

### Authorization before implementation

An audit identifies and plans changes. It does not silently implement them.

### Validation before success claims

Passing automated checks is valuable evidence, but conclusions must remain bounded by what was actually validated.

---

# What This Project Does Not Promise

These skills improve the rigor and consistency of AI-assisted Flutter review and implementation.

They do **not** guarantee:

* absence of bugs
* complete security verification
* 100% test coverage
* perfect runtime performance
* correctness on every physical device
* App Store or Google Play approval
* replacement for platform/device testing
* replacement for profiling when runtime performance matters

Production-readiness conclusions should always remain bounded by the evidence collected during the audit and validation process.

---

# Contributing

Contributions are welcome when they improve correctness, evidence discipline, Flutter-specific reasoning, or reduce false positives.

When proposing changes:

1. Prefer concrete production failure modes over theoretical rules.
2. Avoid architecture or package preferences without technical evidence.
3. Preserve the separation between audit, authorization, implementation, and validation.
4. Avoid duplicating specialist rules across multiple skills.
5. Keep confidence and severity separate.
6. Avoid rules that encourage mechanical or cargo-cult fixes.
7. Include realistic examples when introducing new behavioral guardrails.
8. Keep macOS/Linux and Windows tooling behavior aligned when changing installation or verification behavior.

---

# License

See [LICENSE](LICENSE).

---

## Final Principle

These skills are not designed to make an AI reviewer sound confident.

They are designed to make it **earn its confidence through evidence**.