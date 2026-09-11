# Example Workflows

This directory contains reusable prompts for common Flutter engineering
workflows supported by Antigravity Flutter Skills.

The examples are intentionally lightweight.

They define the task, scope, and operating mode while delegating detailed
review behavior to the relevant skills. They are not substitutes for the
skills themselves.

## Which prompt should I use?

| Goal | Prompt |
|---|---|
| Audit the entire Flutter application | `full-project-audit.md` |
| Audit one feature or user flow | `targeted-feature-audit.md` |
| Investigate a specific bug | `bug-investigation.md` |
| Investigate performance or memory concerns | `performance-audit.md` |
| Review state-management behavior | `state-management-audit.md` |
| Review responsive/adaptive layout behavior | `responsive-ui-audit.md` |
| Review accessibility, RTL, and localization-sensitive UI | `accessibility-rtl-audit.md` |
| Review duplication and convention drift | `codebase-consistency-audit.md` |
| Perform a final audit before release | `pre-release-audit.md` |
| Implement a previously approved audit plan | `implement-approved-audit-plan.md` |
| Validate an implementation that has just been completed | `post-implementation-review.md` |

## Recommended workflow

For substantial production-readiness work:

```text
Audit
  ↓
Evidence-backed findings
  ↓
Implementation plan
  ↓
Explicit approval
  ↓
Implementation
  ↓
Review gate
  ↓
Runtime/device/release verification where required
```

An audit or implementation plan does not authorize code changes.

## Specialist skills

The examples normally use `flutter-production-audit` as the audit and
investigation orchestrator.

It may delegate to relevant specialist skills such as:

- `flutter-state-management`
- `flutter-performance`
- `flutter-codebase-conventions`
- `flutter-responsive`
- `flutter-a11y-rtl`

Specialist skills should be selected based on the actual execution path and
evidence found during the task.

Do not load every specialist mechanically when the task does not require it.

`flutter-review-gate` is reserved for validation after an authorized
implementation. It should not be used as a general audit or investigation
skill.

## Confidence model

Audit and investigation workflows distinguish between:

- **Confirmed**
- **Likely**
- **Needs verification**

Runtime-dependent conclusions should not be presented as confirmed when the
available evidence does not establish them.

## Placeholders

Some prompts contain placeholders such as:

```text
[Describe the bug here]
```

Replace these with the actual feature, issue, flow, or concern before running
the prompt.