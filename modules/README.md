# modules/

Self-contained content packs — **the only place content lives in this system**. Each module holds everything for one organization or context: rules, guides, knowledge, scripts, hooks, and wiring. A module is process, never a place to store actual work. The baseline is just the engine; modules make it do something.

## Structure

Copy `_template/` (via `/add-module`) — it carries detailed examples for every file:

```
modules/<Name>/
├── README.md      # ENTRY POINT: what the module is, its ACTIVATION SCOPE,
│                  # and a routing map into the folders below
├── orient.md      # Optional: module-specific orientation, followed by /orient
├── audit.md       # Optional: module-specific audit checks, run by /audit <name>
├── setup.md       # Optional: module-specific setup steps, run by /setup
├── rules/         # rules-<type>.md files — types and triggers are defined in
│                  # the engine's registries/rule-types.md (global = reserved)
├── guides/        # Deliverable how-tos, wrapped by module-prefixed commands
├── knowledge/     # Facts: identity (about.md), glossaries, repo maps, gotchas
├── scripts/       # Utility scripts the module's commands and guides call
├── hooks/         # Scripts enforcing this module's rules mechanically
└── wiring/        # commands/ (installed by /setup) + hooks.json (registrations)
```

No nested `modules/` inside a module.

## Activation scope

Declared in the module's README — the most important thing it says:

- **`Scope: always`** (the section body begins with that exact line — `/setup` keys on it): a **global** module, active in every session. Its `rules/rules-global.md` is wired into the always-on layer; its identity knowledge is read at orientation. **Highly recommended**: every user has one, named **`Core`** by convention, holding their non-org-specific rules, identity, and knowledge (the engine keys on the scope, not the name).
- **Concrete paths/repos/contexts**: a **scoped** module, activating when the work matches. Vague scope = the module silently never activates.

All active modules compose; on conflict, the more specifically-scoped module wins for its own work.

## Modules extend commands with data

The generic `/orient`, `/audit`, and `/setup` take an optional fuzzy module argument (initials or partial names match) and follow the module's `orient.md`/`audit.md`/`setup.md` when present. Deliverable guides get module-prefixed command wrappers in `wiring/commands/`; mechanical checks register via `wiring/hooks.json`. Never module-specific commands for orient/audit/setup themselves.

## Privacy & portability

Everything here except this README and `_template/` is **gitignored** — modules are local, and each owns its own privacy (identity and private knowledge live inside the module). Import a module by dropping its folder here and re-running `/setup`; remove it by deleting the folder and re-running `/setup`. A module can itself be a git repo to version or share it independently — the engine repo never sees inside modules. `/pull` updates the baseline plus every module repo together (refreshing the wiring afterward), and `/push` commits and pushes the module repos as journal-style backups; the baseline repo is always committed by hand.
