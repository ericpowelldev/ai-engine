# modules/

Self-contained organization packs. Each module holds everything specific to one organization — rules, guides, knowledge, scratch, hooks, and wiring — so the root stays generic and the module can be imported, removed, or set up independently.

## Structure

Each module mirrors the root structure:

```
modules/<Org>/
├── README.md      # The module's ENTRY POINT: what it is, its activation
│                  # scope (paths/repos/contexts it applies to), and a
│                  # routing map into the folders below
├── orient.md      # Optional: module-specific orientation steps, followed
│                  # by /orient <org> (or on scope match)
├── audit.md       # Optional: module-specific audit checks, run by /audit <org>
├── setup.md       # Optional: module-specific setup steps, run by /setup [<org>]
├── rules/         # Org-specific rules-<type>.md files
├── guides/        # Org-specific deliverable guides
├── knowledge/     # Org glossaries, repo maps, system gotchas
├── scratchpad/    # Org-specific brainstorming
├── hooks/         # Org-specific hook scripts
└── wiring/        # Commands/skills/hook registrations to install
```

The generic `/orient`, `/audit`, and `/setup` commands take an optional module argument (fuzzy-matched — "hd" finds HopDrive) and follow the module's `orient.md`/`audit.md`/`setup.md` when present — modules extend those commands with data, not with commands of their own. `/setup` needs no argument to cover modules: its default (and `all`) sets up the baseline plus every module; a module argument just focuses the run.

No `personal/` (personal content is root-only) and no nested `modules/`.

## Activation

The baseline is not aware of specific modules. Each module's `README.md` declares its scope; when the work matches, the agent reads that README first and follows its routing. Module rules extend the generic rules — the rule skills load both tiers.

## Self-containment

Nothing module-specific lives outside the module's folder. All of a module's commands and skills ship in its `wiring/`, installed by `/setup`. Import a module by dropping its folder here and re-running `/setup`; remove it by deleting the folder and re-running `/setup`.

## Privacy

Everything here except this README is **gitignored** — modules stay on your machine.
