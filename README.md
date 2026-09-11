# Antigravity Flutter Skills

Production-focused Flutter skills for **Antigravity** — built for evidence-driven audits, safer implementation, and disciplined validation across real Flutter projects.

> **Understand first. Verify with evidence. Change only with authorization. Validate before claiming success.**

The skill set is architecture-neutral. It works with the patterns already present in your project instead of forcing Bloc, Riverpod, Provider, Dio, `go_router`, a specific database, dependency-injection framework, or folder structure.

---

## Quick Start

### Install into a Flutter project — Recommended

From the root of your Flutter project:

```bash
npx skills add Darshfb/antigravity-flutter-skills --skill '*' --agent antigravity
```

The seven skills are installed project-locally under:

```text
.agents/skills/
├── flutter-a11y-rtl/
├── flutter-codebase-conventions/
├── flutter-performance/
├── flutter-production-audit/
├── flutter-responsive/
├── flutter-review-gate/
└── flutter-state-management/
```

Project-local installation is recommended because the skills stay tied to the project that uses them.

### Preview before installing

```bash
npx skills add Darshfb/antigravity-flutter-skills --list
```

The repository should report:

```text
Found 7 skills
```

### Install one skill only

```bash
npx skills add Darshfb/antigravity-flutter-skills \
  --skill flutter-production-audit \
  --agent antigravity
```

---

## Verify Antigravity Can See the Skills

Installing files and loading them in the current Antigravity session are two different checks.

### 1. Verify the project installation

From the project root:

```bash
npx skills ls -a antigravity
```

Confirm that the Flutter skills are listed.

### 2. Verify discovery inside Antigravity

Restart Antigravity or start a new session for the project, then ask:

```text
Explicitly load and follow `flutter-production-audit`.

Before starting any audit, confirm whether the skill was successfully
discovered and loaded for this workspace.

Do not modify any project files.
```

If Antigravity exposes project skills in its UI, you can also open the skill there and confirm that it resolves from the project's `.agents/skills/` directory.

---

## Global Installation

Use global installation when you want the skills available across Antigravity projects for the current user.

### macOS / Linux

Clone the repository:

```bash
git clone https://github.com/Darshfb/antigravity-flutter-skills.git
cd antigravity-flutter-skills
```

Verify it:

```bash
chmod +x verify.sh
./verify.sh
```

Install globally:

```bash
chmod +x install.sh
./install.sh --global
```

The repository installer uses:

```text
~/.gemini/config/skills/
```

### Windows

Clone the repository and open PowerShell in the repository directory.

Verify it:

```powershell
powershell -ExecutionPolicy Bypass -File .\verify.ps1
```

Install globally:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 --global
```

The Windows installer uses:

```text
%USERPROFILE%\.gemini\config\skills\
```

After global installation, restart Antigravity or start a new session.

### Verify global discovery

Ask Antigravity:

```text
Explicitly load and follow `flutter-production-audit`.

Before doing anything else, confirm whether the skill was successfully
discovered and loaded.

Do not modify project files.
```

---

## Alternative: Script-Based Project Installation

The repository includes native installers for users who do not want to use `npx`.

### macOS / Linux

```bash
./install.sh --project /path/to/flutter/project
```

Or, when the repository itself is being invoked for the current project path:

```bash
./install.sh --project .
```

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1 --project C:\Projects\my_flutter_app
```

Both installers place project-scoped skills under:

```text
<project>/.agents/skills/
```

---

## Manual Project Installation

You can also install without any CLI or installer.

Copy the seven directories inside:

```text
skills/
```

into:

```text
<your-project>/.agents/skills/
```

Then restart Antigravity or start a new session.

---

## The Skills

| Skill | Responsibility |
|---|---|
| `flutter-production-audit` | Orchestrates deep production-readiness audits, bug investigations, evidence classification, and implementation planning |
| `flutter-codebase-conventions` | Keeps changes consistent with the existing project and detects meaningful duplication or convention drift |
| `flutter-state-management` | Reviews state ownership, async semantics, concurrency, cancellation, lifecycle safety, persistence, and rebuild scope |
| `flutter-performance` | Reviews meaningful performance and memory risks without cargo-cult optimization |
| `flutter-responsive` | Reviews Flutter constraints, adaptive layouts, breakpoints, overflow risks, resizing, orientation, and multi-device behavior |
| `flutter-a11y-rtl` | Reviews accessibility, semantics, RTL/LTR behavior, touch targets, text scaling, forms, focus, and localization-sensitive UI |
| `flutter-review-gate` | Performs final validation after an explicitly authorized implementation |

---

## How They Work Together

```text
┌──────────────────────────┐
│ flutter-production-audit │
│       Orchestrator       │
└────────────┬─────────────┘
             │
     ┌───────┼──────────┬───────────────┐
     ▼       ▼          ▼               ▼
   State  Performance  Codebase    Responsive /
                         Rules       A11y / RTL
     └───────┬──────────┴───────────────┘
             ▼
       Findings + Plan
             │
             ▼
      Explicit Approval
             │
             ▼
       Implementation
             │
             ▼
┌──────────────────────────┐
│   flutter-review-gate    │
│     Final Validation     │
└──────────────────────────┘
```

The production-audit skill acts as the orchestrator. Specialist skills are used when their domain is relevant. The review gate is reserved for validation after implementation.

---

## Safety Model

The workflow deliberately separates investigation from modification:

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

An audit does **not** authorize implementation.

A generated implementation plan does **not** authorize implementation either.

Responses such as:

```text
Looks good.
Makes sense.
Thanks.
OK.
```

are not treated as permission to edit the project.

Implementation requires an explicit instruction such as:

```text
Implement the approved plan.
```

---

## Evidence Model

Audit findings separate **confidence** from **severity**.

### Confidence

- **Confirmed** — directly supported by the traced evidence.
- **Likely** — strongly supported, but some relevant behavior remains unverified.
- **Needs verification** — runtime, device, profiling, platform, or additional evidence is required.

### Severity

- 🔴 **CRITICAL**
- 🟠 **HIGH**
- 🟡 **MEDIUM**
- 🔵 **LOW**
- ⚪ **NEEDS VERIFICATION**
- 🟢 **OK**

Example:

```text
🟠 HIGH | Confirmed
🟡 MEDIUM | Likely
⚪ NEEDS VERIFICATION
```

A serious possible consequence does not become a confirmed finding merely because it sounds plausible.

If earlier evidence is later disproved, dependent conclusions must be re-evaluated rather than silently replaced with a new unsupported root cause.

---

## Production-Readiness Discipline

The skills do not equate static checks with production readiness.

These are different forms of evidence:

```text
Static analysis
Automated tests
Measured code coverage
Behavioral coverage
Runtime/device validation
Release-build validation
```

For example:

```text
flutter analyze passes
+
flutter test passes
```

does not automatically prove that:

```text
all paths are covered
runtime behavior is correct
performance is acceptable
platform integrations work on-device
the application is production ready
```

Production-readiness conclusions remain bounded by the evidence actually collected.

---

## Architecture Neutrality

The skills do not treat technology choices as defects by themselves.

These are not findings merely because they exist:

```text
Navigator instead of go_router
Provider instead of Bloc
Bloc instead of Riverpod
get_it instead of another DI framework
http instead of Dio
manual serialization instead of code generation
feature-first instead of layer-first organization
```

Architecture changes should be recommended only when the current implementation creates a concrete technical problem.

---

## No Cargo-Cult Flutter Advice

The skills intentionally avoid mechanical recommendations such as:

- adding `const` everywhere
- adding `RepaintBoundary` everywhere
- adding selectors everywhere
- using `SingleChildScrollView` for every overflow
- using `shrinkWrap: true` for every nested list
- adding `Expanded` to every `Row` or `Column` issue
- wrapping every widget in `Semantics`
- mirroring every icon in RTL
- caching every request
- moving every expensive-looking operation to an isolate
- extracting every repeated block into a shared abstraction
- selecting Bloc event transformers from event names alone

Recommendations should follow the actual execution path, constraints, semantics, and user intent.

---

## Example Workflows

Ready-to-use prompts live in [`examples/`](examples/).

| Goal | Prompt |
|---|---|
| Full production-readiness audit | [`full-project-audit.md`](examples/full-project-audit.md) |
| Audit one feature or flow | [`targeted-feature-audit.md`](examples/targeted-feature-audit.md) |
| Investigate a bug | [`bug-investigation.md`](examples/bug-investigation.md) |
| Investigate performance or memory | [`performance-audit.md`](examples/performance-audit.md) |
| Review state management | [`state-management-audit.md`](examples/state-management-audit.md) |
| Review responsive/adaptive UI | [`responsive-ui-audit.md`](examples/responsive-ui-audit.md) |
| Review accessibility and RTL | [`accessibility-rtl-audit.md`](examples/accessibility-rtl-audit.md) |
| Review duplication and conventions | [`codebase-consistency-audit.md`](examples/codebase-consistency-audit.md) |
| Final pre-release audit | [`pre-release-audit.md`](examples/pre-release-audit.md) |
| Implement an approved audit plan | [`implement-approved-audit-plan.md`](examples/implement-approved-audit-plan.md) |
| Validate completed implementation | [`post-implementation-review.md`](examples/post-implementation-review.md) |

See [`examples/README.md`](examples/README.md) for the workflow guide.

---

## Recommended Workflow

### 1. Install into the project

```bash
npx skills add Darshfb/antigravity-flutter-skills --skill '*' --agent antigravity
```

### 2. Verify installation

```bash
npx skills ls -a antigravity
```

### 3. Restart Antigravity and confirm discovery

```text
Explicitly load and follow `flutter-production-audit`.

Before starting the audit, confirm whether the skill was successfully
discovered and loaded for this workspace.

Do not modify project files.
```

### 4. Run a read-only audit

Start with:

```text
examples/full-project-audit.md
```

### 5. Review the evidence and implementation plan

Pay particular attention to:

- Critical / High findings
- confidence classification
- Needs-verification items
- runtime/device checks still required
- proposed implementation scope

### 6. Explicitly authorize implementation

```text
Implement the approved production-audit plan.
```

### 7. Validate

After implementation, use `flutter-review-gate` to validate the completed work and report what remains unverified.

---

## Repository Structure

```text
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
    ├── flutter-codebase-conventions/
    │   └── SKILL.md
    ├── flutter-state-management/
    │   └── SKILL.md
    ├── flutter-performance/
    │   └── SKILL.md
    ├── flutter-responsive/
    │   └── SKILL.md
    ├── flutter-a11y-rtl/
    │   └── SKILL.md
    └── flutter-review-gate/
        └── SKILL.md
```

---

## Repository Verification

Before publishing changes to the skill set, verify the repository.

### macOS / Linux

```bash
./verify.sh
```

### Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\verify.ps1
```

A successful run should finish with:

```text
Verification PASSED
Errors:   0
```

---

## Uninstall

### Project — macOS / Linux

```bash
./uninstall.sh --project /path/to/flutter/project
```

### Global — macOS / Linux

```bash
./uninstall.sh --global
```

### Project — Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\uninstall.ps1 --project C:\Projects\my_flutter_app
```

### Global — Windows

```powershell
powershell -ExecutionPolicy Bypass -File .\uninstall.ps1 --global
```

If you installed through `npx skills`, you can instead use the `skills` CLI's removal flow to manage installed skills.

---

## Platform Support

| Platform | Project installation | Global installation | Repository scripts |
|---|---:|---:|---:|
| macOS | ✅ | ✅ | Bash |
| Linux | ✅ | ✅ | Bash |
| Windows | ✅ | ✅ | PowerShell |

---

## Contributing

Contributions are welcome when they improve correctness, evidence discipline, Flutter-specific reasoning, or reduce false positives.

When proposing changes:

1. Prefer concrete production failure modes over theoretical rules.
2. Avoid architecture or package preferences without technical evidence.
3. Preserve the boundary between audit, authorization, implementation, and validation.
4. Keep confidence and severity separate.
5. Avoid rules that encourage mechanical or cargo-cult fixes.
6. Include realistic examples when introducing behavioral guardrails.
7. Keep Windows and macOS/Linux tooling behavior aligned.

---

## What This Project Does Not Promise

These skills improve the rigor and consistency of AI-assisted Flutter review and implementation. They do not guarantee:

- absence of bugs
- complete security verification
- 100% test coverage
- perfect runtime performance
- correctness on every physical device
- App Store or Google Play approval
- replacement for platform/device testing
- replacement for profiling when runtime performance matters

---

## License

See [LICENSE](LICENSE).

---

## Final Principle

These skills are not designed to make an AI reviewer sound confident.

They are designed to make it **earn its confidence through evidence**.
