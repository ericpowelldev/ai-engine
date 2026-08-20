# modules/

Self-contained content packs — **the only place content lives in this system**. Each module holds everything for one organization or context: rules, guides, knowledge, scripts, hooks, and wiring. A module is process, never a place to store actual work. The baseline is just the engine; modules make it do something.

## Structure

Every module shares one shape. Copy `_template/` (via `/add-module`) to start a new one — it carries the canonical layout with detailed examples for every file, and is the reference for what a module contains. Modules never nest inside each other.

## Activation scope

Declared in the module's README — the most important thing it says:

- **`Scope: always`** (the section body begins with that exact line — `/setup` keys on it): a **global** module, active in every session. Its global rules are wired into the always-on layer and its knowledge is read at orientation. **Highly recommended**: every user has one, named **`Core`** by convention, holding their non-org-specific rules, identity, and knowledge (the engine keys on the scope, not the name).
- **Concrete paths/repos/contexts**: a **scoped** module, activating when the work matches. Vague scope = the module silently never activates.

All active modules compose; on conflict, the more specifically-scoped module wins for its own work.

## Modules extend commands with data

The generic `/orient`, `/audit`, and `/setup` take an optional fuzzy module argument (initials or partial names match) and follow the module's own orient/audit/setup data when present. Deliverable guides get module-prefixed command wrappers; mechanical checks register through the module's wiring. Never module-specific commands for orient/audit/setup themselves.

## Privacy & portability

Everything here except this README and `_template/` is **gitignored** — modules are local, and each owns its own privacy (identity and private knowledge live inside the module). Import a module by dropping its folder here and re-running `/setup`; remove it by deleting the folder and re-running `/setup`. A module can itself be a git repo to version or share it independently — the engine repo never sees inside modules. `/pull` updates the baseline plus every module repo together (refreshing the wiring afterward), and `/push` commits and pushes the module repos as journal-style backups; the baseline repo is always committed by hand.
