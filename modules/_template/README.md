# <Module Name>

<!-- One or two sentences: what this module is — the organization or context it covers,
     and who the user is within it. This README is the module's ENTRY POINT: the agent
     reads it first whenever the module activates. -->

## Activation scope

<!-- REQUIRED, and the most important section: a module with a vague scope silently
     never activates. Two forms:

     For a GLOBAL module (active in every session), the section body must begin with
     this exact line — /setup keys on it to wire always-on rules:

Scope: always

     For a scoped module, list the CONCRETE paths, repos, and contexts it applies to: -->

This module applies when the work touches any of:

- Anything under `~/path/to/the/org's/workspace/`
- Any <org> repo opened directly
- Any task about <org>'s systems, customers, or domain

## Layout

<!-- A folder-level map: name each top-level folder and what it holds — no deeper.
     Don't list or explain individual files; each file, and any nested README, owns that.
     Knowledge loading: a global module has all of `knowledge/` read during orientation;
     a scoped module names the docs to always load in its `orient.md`, the rest are lookups. -->

| Folder | Holds |
|---|---|
| `rules/` | The module's rules — global rules load every session, typed rules load on demand through their skills (types and triggers defined in the engine's `registries/`) |
| `knowledge/` | Facts and identity the module needs (see the loading note above) |
| `guides/` | Deliverable procedures, run through the module's `/<module>-*` commands |
| `scripts/` | Utility scripts the module's commands and guides call (rule enforcement lives in `hooks/`) |

## Wiring

<!-- What `wiring/` ships: module-prefixed command wrappers and hook registrations.
     Installed by /setup; the whole module stays local. -->
