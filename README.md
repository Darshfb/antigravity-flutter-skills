Antigravity Flutter Skills

A production-focused Flutter skill set for Antigravity, designed to improve full-project audits, implementation safety, codebase consistency, state-management reasoning, performance analysis, responsive UI, accessibility/RTL review, and post-implementation validation.

Understand first. Verify with evidence. Change only with authorization. Validate before claiming success.

These skills are intentionally architecture-neutral. They do not force Bloc, Riverpod, Provider, go_router, Dio, a particular database, dependency-injection framework, or project structure.

They work with the architecture already present in a Flutter project and report problems only when there is concrete evidence of a correctness, reliability, performance, accessibility, maintainability, or production-readiness risk.

Quick Start

Recommended: install into the current Flutter project

Run this from the root of the Flutter project where you want Antigravity to use the skills:

npx skills add Darshfb/antigravity-flutter-skills --skill '*' --agent antigravity

The skills CLI discovers all seven skills in this repository and installs them for Antigravity at project scope.

Expected project structure:

your_flutter_project/
└── .agents/
    └── skills/
        ├── flutter-a11y-rtl/
        ├── flutter-codebase-conventions/
        ├── flutter-performance/
        ├── flutter-production-audit/
        ├── flutter-responsive/
        ├── flutter-review-gate/
        └── flutter-state-management/

Project installation is the recommended starting point because it keeps the skill set tied to one workspace and makes it easy to test or share with that project.

Preview the skills before installing

npx skills add Darshfb/antigravity-flutter-skills --list

The repository should report 7 skills.

Install only one skill

npx skills add Darshfb/antigravity-flutter-skills \
  --skill flutter-production-audit \
  --agent antigravity

Verify the project installation from the CLI

From the same project root:

npx skills ls -a antigravity

You should see the installed Flutter skills listed for the current project.

Verify Antigravity actually discovered the skills

After installation:

Restart Antigravity, or start a new Antigravity session for the project.

Confirm the project is opened from its actual workspace root.

If Antigravity exposes project skills in its UI, open one and confirm it resolves from .agents/skills/.

Run this lightweight discovery check in a new conversation:

Explicitly load and follow `flutter-production-audit`.

Before starting any audit, confirm whether the skill was successfully
discovered and loaded for this workspace.

Do not modify any project files.

For the strongest practical verification, use both the CLI listing and the Antigravity runtime check. The CLI confirms installation; the runtime check confirms that the current Antigravity session can discover and load the skill.

Installation

The repository supports both project-scoped and global installation.

Recommended order:

Project installation with npx skills

Global Antigravity installation with npx skills

Repository scripts when you specifically prefer script-based installation

Manual copying as a fallback

1. Project Installation — Recommended

Project scope is the default for skills.

Run from the Flutter project's root directory:

npx skills add Darshfb/antigravity-flutter-skills --skill '*' --agent antigravity

This installs all seven skills into the current project for Antigravity.

Expected location:

<project>/.agents/skills/

Non-interactive project installation

Useful for repeatable setup:

npx skills add Darshfb/antigravity-flutter-skills \
  --skill '*' \
  --agent antigravity \
  --yes

Install selected skills only

Example:

npx skills add Darshfb/antigravity-flutter-skills \
  --skill flutter-production-audit \
  --skill flutter-review-gate \
  --agent antigravity

2. Global Antigravity Installation

Use global installation when you want these skills available across Antigravity projects for the current user.

The same command works from macOS, Linux, and Windows as long as Node.js/npm and npx are available.

npx skills add Darshfb/antigravity-flutter-skills \
  --skill '*' \
  --agent antigravity \
  --global

The Antigravity global location managed by the skills CLI is:

~/.gemini/antigravity/skills/

On Windows, ~ resolves to the current user's home/profile directory.

Non-interactive global installation

npx skills add Darshfb/antigravity-flutter-skills \
  --skill '*' \
  --agent antigravity \
  --global \
  --yes

Verify the global installation

npx skills ls -g -a antigravity

Then restart Antigravity or start a new session and run:

Explicitly load and follow `flutter-production-audit`.

Before doing anything else, confirm whether the skill was successfully
discovered and loaded.

Do not modify project files.

3. Update Installed Skills

Project scope:

npx skills update

Global scope:

npx skills update -g

List project skills:

npx skills list

List global skills:

npx skills ls -g

Filter to Antigravity:

npx skills ls -a antigravity

Global Antigravity only:

npx skills ls -g -a antigravity

4. Remove Skills Installed with the Skills CLI

Interactive removal:

npx skills remove

Remove from global scope:

npx skills remove --global

Filter removal to Antigravity:

npx skills remove --agent antigravity

Use the interactive selection when you want to keep unrelated skills installed by other repositories.

5. Script-Based Installation

The repository also includes native installation, verification, and uninstall scripts.

These are useful when you prefer a repository-managed copy workflow rather than the skills CLI.

Clone the repository

git clone https://github.com/Darshfb/antigravity-flutter-skills.git
cd antigravity-flutter-skills

macOS / Linux

Verify:

chmod +x verify.sh
./verify.sh

Project installation:

chmod +x install.sh
./install.sh --project /path/to/flutter/project

Current directory:

./install.sh --project .

Project destination:

<project>/.agents/skills/

Global script-based installation:

./install.sh --global

The repository's script-based global destination is:

~/.gemini/config/skills/

The npx skills global Antigravity install uses Antigravity's CLI-managed global skills location, while this repository's native installer keeps its existing compatibility destination. Prefer one global installation method consistently to avoid duplicate copies being discovered from multiple locations.

Uninstall from project:

./uninstall.sh --project /path/to/flutter/project

Uninstall script-based global copy:

./uninstall.sh --global

Windows PowerShell

Verify with Windows PowerShell:

powershell -ExecutionPolicy Bypass -File .\verify.ps1

Or PowerShell 7:

pwsh -NoProfile -File .\verify.ps1

Project installation:

powershell -ExecutionPolicy Bypass -File .\install.ps1 --project .

Or with PowerShell 7:

pwsh -NoProfile -File .\install.ps1 --project .

Another project:

powershell -ExecutionPolicy Bypass -File .\install.ps1 --project C:\Projects\my_flutter_app

Project destination:

<project>\.agents\skills\

Global installation:

powershell -ExecutionPolicy Bypass -File .\install.ps1 --global

Or with PowerShell 7:

pwsh -NoProfile -File .\install.ps1 --global

Script-based Windows global destination:

%USERPROFILE%\.gemini\config\skills\

Uninstall project copy:

powershell -ExecutionPolicy Bypass -File .\uninstall.ps1 --project .

Uninstall script-based global copy:

powershell -ExecutionPolicy Bypass -File .\uninstall.ps1 --global

6. Manual Project Installation

If you do not want to run either npx or the installer scripts:

Download or clone this repository.

Copy the seven directories inside skills/.

Paste them into:

<your-project>/.agents/skills/

Expected structure:

<your-project>/
└── .agents/
    └── skills/
        ├── flutter-a11y-rtl/
        │   └── SKILL.md
        ├── flutter-codebase-conventions/
        │   └── SKILL.md
        ├── flutter-performance/
        │   └── SKILL.md
        ├── flutter-production-audit/
        │   └── SKILL.md
        ├── flutter-responsive/
        │   └── SKILL.md
        ├── flutter-review-gate/
        │   └── SKILL.md
        └── flutter-state-management/
            └── SKILL.md

Restart Antigravity or start a new session after copying the skills.

Installation Scope Summary

Goal

Recommended command

Scope

Use the skills in one Flutter project

npx skills add Darshfb/antigravity-flutter-skills --skill '*' --agent antigravity

Project

Use the skills across Antigravity projects

npx skills add Darshfb/antigravity-flutter-skills --skill '*' --agent antigravity --global

Global

Preview available skills

npx skills add Darshfb/antigravity-flutter-skills --list

No installation

Verify project-installed skills

npx skills ls -a antigravity

Project

Verify global Antigravity skills

npx skills ls -g -a antigravity

Global

Use repository-managed scripts

install.sh / install.ps1

Project or global

Avoid all installers

Copy skills/* to .agents/skills/

Project

Avoid Duplicate Installations

Antigravity may discover skills from more than one location.

Potential locations include:

<project>/.agents/skills/
~/.gemini/antigravity/skills/
~/.gemini/config/skills/

When diagnosing discovery or version conflicts:

Check project installation:

npx skills ls -a antigravity

Check global installation:

npx skills ls -g -a antigravity

Open the skill from Antigravity's project skills UI when available and verify which path is being used.

Avoid keeping stale copies of the same skill in multiple global locations unless intentional.

The repository installers do not automatically delete legacy copies.

Skills

The repository contains seven complementary Flutter skills.

Skill

Purpose

flutter-production-audit

Orchestrates comprehensive production-readiness audits and coordinates the specialist skills

flutter-state-management

Reviews state ownership, async semantics, concurrency, cancellation, optimistic updates, lifecycle safety, persistence, and rebuild scope

flutter-performance

Reviews meaningful performance and memory risks including rebuilds, startup, I/O, images, caching, large datasets, background work, and resource lifetime

flutter-codebase-conventions

Keeps changes consistent with the existing project and detects meaningful duplication, convention drift, and forced abstractions

flutter-responsive

Reviews Flutter constraints, adaptive layouts, overflow risks, breakpoints, safe areas, large text, orientation, resizing, and multi-window behavior

flutter-a11y-rtl

Reviews accessibility, semantics, RTL/LTR behavior, touch targets, text scaling, forms, focus, and localization-sensitive UI

flutter-review-gate

Performs the final post-implementation validation before an implementation can be considered complete

How the System Works

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

flutter-production-audit determines what needs to be investigated and routes relevant areas to specialist skills.

The specialist skills provide domain-specific reasoning.

After an approved implementation is complete, flutter-review-gate performs final validation.

Safety Model

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

A production audit does not automatically authorize code changes.

A plan is not approval.

Implementation requires an explicit instruction such as:

Implement the approved plan.

This prevents audit findings from silently turning into unauthorized changes.

Evidence-Driven Reviews

Confidence

Confirmed — the relevant execution path was traced and the problem was verified from available evidence.

Likely — strong evidence exists, but part of the behavior could not be fully verified.

Needs verification — runtime, device, profiling, platform, or additional evidence is required.

Severity

🔴 CRITICAL

🟠 HIGH

🟡 MEDIUM

🔵 LOW

⚪ NEEDS VERIFICATION

🟢 OK

Severity and confidence are intentionally independent.

Production-Readiness Discipline

Possible conclusions include:

Production ready based on reviewed and validated scope

Production ready pending specified runtime/device verification

Conditionally ready

Not production ready yet

Insufficient coverage to determine

A clean static analysis result alone does not establish production readiness.

Passing tests alone do not establish production readiness either.

Test and Coverage Discipline

The skills distinguish between:

Tests passing
Code coverage
Behavioral coverage
Runtime/device validation
Release-build validation

Passing tests do not mean:

100% covered
fully covered
all paths verified
no bugs remain

Percentage-based coverage claims require measured evidence such as LCOV or equivalent.

Architecture Neutrality

The following are not findings by themselves:

Navigator instead of go_router
Provider instead of Bloc
Bloc instead of Riverpod
get_it instead of another DI framework
http instead of Dio
manual serialization instead of code generation
feature-first instead of layer-first organization

Architecture changes are recommended only when the existing implementation creates a concrete technical problem.

Anti-Cargo-Cult Review Philosophy

The system does not automatically recommend:

const everywhere

RepaintBoundary everywhere

selectors everywhere

SingleChildScrollView for every overflow

shrinkWrap: true for every nested list

Expanded for every Row or Column issue

Semantics around every widget

mirroring every icon for RTL

caching every request

moving every expensive-looking operation to an isolate

converting every repeated implementation into a shared abstraction

choosing Bloc event transformers from event names alone

Recommendations must follow the actual semantics and execution path of the project.

State-Management Reasoning

The state-management skill supports:

Bloc

Cubit

Riverpod

Provider

ChangeNotifier

signals

setState

similar approaches

It reasons about:

droppable
restartable
sequential
concurrent
debounce
throttle
deduplication
cancellation
optimistic updates

Preserve user intent first. Optimize concurrency second.

Performance Philosophy

The performance skill focuses on meaningful risks rather than micro-optimizations.

It reviews:

rebuild scope

build-path work

startup initialization

database access

networking

large datasets

serialization/parsing

image decoding/caching

background work

timers/subscriptions

resource ownership

long-lived memory

unbounded collections

peak-memory behavior

Static inspection does not automatically prove jank, frame drops, OOM, slow startup, or good runtime performance.

Responsive and Adaptive UI

The responsive skill reasons using Flutter's actual constraint system.

It distinguishes between:

bounded and unbounded constraints

genuine small-screen overflow

nested-scroll constraint problems

incorrect Expanded / Flexible usage

intentional vs accidental fixed dimensions

responsive vs adaptive behavior

phone, tablet, desktop, web, foldable, split-screen, and live resizing

Accessibility, RTL, and Localization

The accessibility and RTL skill reviews:

directionality

RTL/LTR behavior

directional icons

semantics

screen-reader usability

text scaling

touch targets

forms

focus

dialogs/modals

dynamic announcements

bidirectional text

localization-sensitive layouts

translated text expansion

It avoids mechanical rules such as mirroring every icon or wrapping every widget in Semantics.

Codebase Consistency

Reuse before create — but do not force reuse.

Before introducing new widgets, services, helpers, repositories, validators, formatters, or utilities, the project is searched for existing functionality serving the same responsibility.

Visual similarity or repeated lines alone are not enough to justify abstraction.

Review Gate

flutter-review-gate runs only after explicitly authorized implementation has been completed.

It reviews:

Scope

Correctness

Codebase consistency

UI when applicable

Performance/resources when applicable

Formatting

Static analysis

Tests and runtime-verification boundaries

Final validation status

Final classifications:

Validated

Partially validated

Not validated

Example Workflows

Ready-to-use prompts live under:

examples/

Goal

Prompt

Audit the entire Flutter application

examples/full-project-audit.md

Audit one feature or user flow

examples/targeted-feature-audit.md

Investigate a specific bug

examples/bug-investigation.md

Investigate performance or memory concerns

examples/performance-audit.md

Review state-management behavior

examples/state-management-audit.md

Review responsive/adaptive UI

examples/responsive-ui-audit.md

Review accessibility and RTL

examples/accessibility-rtl-audit.md

Review duplication and convention drift

examples/codebase-consistency-audit.md

Perform a final pre-release audit

examples/pre-release-audit.md

Implement an approved audit plan

examples/implement-approved-audit-plan.md

Validate completed implementation

examples/post-implementation-review.md

See examples/README.md for the full workflow guide.

Recommended Production Workflow

1. Install into the project

npx skills add Darshfb/antigravity-flutter-skills --skill '*' --agent antigravity

2. Verify installation

npx skills ls -a antigravity

3. Confirm Antigravity discovery

Restart Antigravity or open a new session, then:

Explicitly load and follow `flutter-production-audit`.

Before starting the audit, confirm whether this skill was successfully
discovered and loaded for this workspace.

Do not modify project files.

4. Run the audit

Use:

examples/full-project-audit.md

5. Review findings and plan

Review Critical/High findings, Medium findings, Needs-verification items, the implementation plan, and the readiness verdict.

6. Explicitly authorize implementation

Implement the approved production-audit plan.

7. Implement

Use:

examples/implement-approved-audit-plan.md

8. Validate

flutter-review-gate performs final validation.

9. Complete runtime verification

Depending on the app, this may include:

Android physical-device testing

iOS physical-device testing

background/foreground testing

process-death testing

notification verification

permission-denial testing

release-build testing

Flutter DevTools profiling

store-specific validation

Repository Structure

antigravity-flutter-skills/
├── README.md
├── LICENSE
├── install.sh
├── uninstall.sh
├── verify.sh
├── install.ps1
├── uninstall.ps1
├── verify.ps1
│
├── examples/
│   ├── README.md
│   ├── full-project-audit.md
│   ├── targeted-feature-audit.md
│   ├── bug-investigation.md
│   ├── performance-audit.md
│   ├── state-management-audit.md
│   ├── responsive-ui-audit.md
│   ├── accessibility-rtl-audit.md
│   ├── codebase-consistency-audit.md
│   ├── pre-release-audit.md
│   ├── implement-approved-audit-plan.md
│   └── post-implementation-review.md
│
└── skills/
    ├── flutter-production-audit/
    │   └── SKILL.md
    ├── flutter-state-management/
    │   └── SKILL.md
    ├── flutter-performance/
    │   └── SKILL.md
    ├── flutter-codebase-conventions/
    │   └── SKILL.md
    ├── flutter-responsive/
    │   └── SKILL.md
    ├── flutter-a11y-rtl/
    │   └── SKILL.md
    └── flutter-review-gate/
        └── SKILL.md

Platform and Installation Support

Platform

Project via npx skills

Global via npx skills

Native scripts

macOS

✅

✅

✅ Bash

Linux

✅

✅

✅ Bash

Windows

✅

✅

✅ PowerShell

The project-scoped npx skills workflow is the recommended default.

Design Goals

Evidence over assumptions

Report what the code supports, not what merely sounds plausible.

Correctness over style

Do not turn architectural or stylistic preferences into production findings.

User intent over concurrency convenience

Do not drop, cancel, serialize, or merge user actions without understanding their semantics.

Performance evidence over folklore

Do not recommend Flutter performance techniques mechanically.

Semantic reuse over superficial DRYness

Reuse existing functionality when responsibilities genuinely match.

Accessibility over checklist compliance

Review actual user accessibility rather than counting Semantics widgets.

Constraints over screenshots

Responsive decisions should follow available layout constraints, not one device size.

Authorization before implementation

An audit identifies and plans changes. It does not silently implement them.

Validation before success claims

Passing automated checks is valuable evidence, but conclusions must remain bounded by what was actually validated.

What This Project Does Not Promise

These skills improve the rigor and consistency of AI-assisted Flutter review and implementation.

They do not guarantee:

absence of bugs

complete security verification

100% test coverage

perfect runtime performance

correctness on every physical device

App Store or Google Play approval

replacement for platform/device testing

replacement for profiling when runtime performance matters

Production-readiness conclusions should always remain bounded by the evidence collected during the audit and validation process.

Contributing

Contributions are welcome when they improve correctness, evidence discipline, Flutter-specific reasoning, or reduce false positives.

When proposing changes:

Prefer concrete production failure modes over theoretical rules.

Avoid architecture or package preferences without technical evidence.

Preserve the separation between audit, authorization, implementation, and validation.

Avoid duplicating specialist rules across multiple skills.

Keep confidence and severity separate.

Avoid rules that encourage mechanical or cargo-cult fixes.

Include realistic examples when introducing new behavioral guardrails.

Keep macOS/Linux and Windows tooling behavior aligned when changing installation or verification behavior.

Keep project and global installation instructions aligned with current Antigravity and skills CLI behavior.

License

See LICENSE.

Final Principle

These skills are not designed to make an AI reviewer sound confident.

They are designed to make it earn its confidence through evidence.