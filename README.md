# Antigravity Flutter Skills

Production-focused Agent Skills for Flutter development with Google Antigravity.

This project extends Antigravity with reusable Flutter workflows focused on real-world code quality, production readiness, performance, state management, responsive UI, accessibility, RTL support, codebase consistency, and final validation.

These skills are designed to complement the official Dart and Flutter Agent Skills, not replace them.

## Why?

AI coding agents are very good at generating Flutter code, but production Flutter applications need more than code generation.

These skills encourage Antigravity to:

- understand the existing project before changing it
- audit complete application flows instead of isolated files
- find real bugs and edge cases
- detect async and lifecycle problems
- identify meaningful performance issues
- reuse existing widgets and services before creating new ones
- respect the project's existing architecture and state-management approach
- review responsive layouts
- review accessibility and RTL behavior
- validate changes before declaring work complete

The goal is not to force a specific Flutter architecture.

The goal is to make Antigravity behave more like a careful senior Flutter engineer working inside an existing production codebase.

## Included Skills

### flutter-production-audit

The main orchestration skill.

Performs deep production-readiness reviews across the complete Flutter application.

It can investigate:

- correctness
- runtime failures
- edge cases
- async and concurrency issues
- lifecycle problems
- state consistency
- networking
- persistence and caching
- localization
- Android and iOS integrations
- performance
- architecture
- security and privacy risks
- maintainability problems

### flutter-codebase-conventions

Encourages Antigravity to understand the existing codebase before creating new components.

Core principle:

**Reuse before create.**

Before creating a new widget, service, helper, repository, validator, formatter, or abstraction, the agent should search for an existing implementation serving the same role.

### flutter-state-management

Reviews state ownership and state flows without forcing a specific library.

Designed to work with existing approaches including:

- Bloc
- Cubit
- Riverpod
- Provider
- ChangeNotifier
- Signals
- setState
- other Flutter state-management approaches

Focuses on:

- async safety
- race conditions
- stale state
- duplicated state
- lifecycle safety
- rebuild scope
- loading and error states
- concurrency

### flutter-performance

Reviews meaningful Flutter performance risks such as:

- unnecessary rebuilds
- expensive work during build
- inefficient lists
- image handling
- resource leaks
- excessive I/O
- repeated network/database operations
- startup work
- caching problems

It intentionally avoids cargo-cult micro-optimizations.

### flutter-a11y-rtl

Reviews user-facing Flutter UI for:

- accessibility
- semantics
- touch targets
- text scaling
- RTL/LTR correctness
- directional layouts
- Arabic and multilingual UI issues
- localization-related layout problems

### flutter-responsive

Reviews and builds layouts for:

- phones
- tablets
- desktop
- web
- orientation changes
- split-screen
- large text
- different available constraints

### flutter-review-gate

The final quality gate after implementation.

It reviews the completed changes and performs appropriate final validation such as:

- scope review
- correctness review
- codebase consistency
- UI review when relevant
- performance review when relevant
- formatting
- static analysis
- relevant tests
- final reporting

## Installation

Clone the repository:

    git clone https://github.com/YOUR_USERNAME/antigravity-flutter-skills.git
    cd antigravity-flutter-skills

### Global installation

Install the skills for all Antigravity projects:

    ./install.sh --global

The skills will be installed into:

    ~/.gemini/config/skills/

Restart Antigravity or start a new conversation after installation.

### Project-only installation

Install the skills only inside a specific Flutter project:

    ./install.sh --project /path/to/flutter/project

Or, when pointing to the current project:

    ./install.sh --project .

Project-specific skills are installed into:

    .agents/skills/

## Verify Installation

Open Antigravity and ask:

    List all available Flutter-related skills, including custom global skills.

You should see:

- flutter-production-audit
- flutter-codebase-conventions
- flutter-state-management
- flutter-performance
- flutter-a11y-rtl
- flutter-responsive
- flutter-review-gate

## Usage

Antigravity can discover relevant skills automatically based on their descriptions.

You can also explicitly request a skill.

For example:

    Use flutter-production-audit to perform a complete production-readiness audit of this Flutter project.

## Full Project Audit

A ready-to-use audit prompt is available at:

    examples/full-project-audit.md

Use it when you want Antigravity to deeply inspect a Flutter project and create a prioritized implementation plan without modifying the code.

## Audit and Fix

A ready-to-use audit-and-fix prompt is available at:

    examples/audit-and-fix.md

Use it when you want Antigravity to investigate the project and fix confirmed production issues.

## Philosophy

These skills intentionally do not force:

- Clean Architecture
- Bloc
- Riverpod
- Provider
- GetX
- Dio
- http
- get_it
- a specific router
- a specific database
- a specific folder structure

Instead, the agent should first understand the existing project and work within its conventions unless there is a concrete technical reason to change them.

The core principles are:

1. Understand before changing.
2. Reuse before creating.
3. Fix real problems before theoretical ones.
4. Preserve working architecture.
5. Optimize only where it matters.
6. Verify assumptions with evidence.
7. Validate before declaring success.

## Official Flutter and Dart Skills

Antigravity Flutter Skills are designed to work alongside the official Dart and Flutter Agent Skills.

When an official specialized skill is available, Antigravity can use it together with these production-focused skills.

## Uninstall

Remove global installation:

    ./uninstall.sh --global

Remove skills from a project:

    ./uninstall.sh --project /path/to/project

## License

MIT
