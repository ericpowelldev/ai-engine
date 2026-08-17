# AI Baseline

This folder — the **baseline folder**, wherever it lives and whatever it's named — is the engine of a modular rules system for working with an AI agent. The baseline itself carries **no content and no opinions**: all rules, guides, knowledge, and scratch live in **modules**, and this file only defines how the system works. Follow these mechanics in every session.

## Modules

A module is a self-contained pack under `modules/<Name>/` holding an organization's or context's rules, guides, knowledge, scratchpad, hooks, and wiring. Each module's `README.md` is its entry point and declares its **activation scope**:

- **`Scope: always`** — a global module, active in every session (working style, cross-context rules, the user's identity).
- **Concrete paths/repos/contexts** — the module activates when the work matches.

Multiple modules are active at once: every always-scoped module plus any scope-matched one. Their content composes; on conflict, the more specifically-scoped module wins for its own work. **Before starting work, identify the active modules** — read each always-scoped module's README (plus its identity knowledge) and check the scoped modules for a match; read a matching module's README first and follow its routing.

`modules/_template/` is the committed scaffold: copy it (via `/add-module`) to build a new module. Everything else under `modules/` is gitignored — modules are local and own their own privacy.

## Rule types

`general`, `coding`, `testing`, `planning`, `documenting`, `designing`.

- **`general`** rules are always-on behavior: each always-scoped module's `rules/rules-general.md` is wired into the user-level `~/.claude/CLAUDE.md` by `/setup`, so they load with every session.
- **Typed** rules load on demand: each type has a skill whose trigger description says when to load it; the skill reads `rules/rules-<type>.md` from **every active module**. Contexts compose — planning work that produces code loads both planning and coding rules.
- Every rule has a domain-prefixed name (`coding-modular`) so it can be referred to directly. Rules are brief, imperative, one concern each.

## Capture flow

An agent's session memory is only the capture layer. Durable content graduates into a module via `/add-entry` (classifies rule vs. knowledge by the content's shape, places it in the owning active module) — and `/add-module` when no module fits.

## Wiring

- **Commands own procedures; modules contribute data.** `/orient`, `/audit`, and `/setup` take an optional fuzzy module argument and follow the module's `orient.md`/`audit.md`/`setup.md` when present.
- **Guides are commands** named for the deliverable, shipped in the owning module's `wiring/commands/` with the module prefix.
- **Hooks** enforce rules mechanically: a module registers its hook scripts via `wiring/hooks.json`; the root `hooks/` folder holds only engine tooling (`setup.sh`).
- `/setup` installs and refreshes everything (see `SETUP.md`); `/orient` re-orients a session — do its steps on the first message of a session when the work isn't already stated.
- Claude-specific plumbing lives in `.claude/`; module wiring is installed to the user level and never committed here.
