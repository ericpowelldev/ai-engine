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

## Routing

<!-- A table the agent follows after reading this file: what to read, when.
     Knowledge is free-form: any file, any name — no filename is guaranteed. For a doc
     orientation must always load (identity, workspace map), write "read during
     orientation" in its When cell; /orient reads exactly the docs marked that way. -->

| Read | When |
|---|---|
| `knowledge/<file>.md` | <e.g. who the user is here> — read during orientation |
| `knowledge/<file>.md` | <the situation that calls for it> |
| `rules/rules-<type>.md` | Loaded automatically by the rule-type skills — types and their triggers are defined in the engine's `registries/rule-types.md` |
| `guides/` | Producing a deliverable — via the `/<module>-*` commands |
| `scripts/` | Utility scripts the module's commands and guides call (rule enforcement lives in `hooks/`) |
| `scratchpad/` | Module-specific brainstorming |

## Wiring

<!-- What `wiring/` ships: command wrappers (module-prefixed), hook registrations
     (`wiring/hooks.json`). Installed by /setup; the whole module stays local. -->
