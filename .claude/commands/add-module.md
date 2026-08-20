---
description: Scaffold a new self-contained module from the template and install its wiring
---

Create a new module. The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, the baseline folder is the current project root).

The module: $ARGUMENTS

If no name was given, ask for it. Then:

## 1. Gather what the scaffold needs

Ask the user (in one round of questions, skipping anything already stated):

- **Activation scope first** — is this a **global** module (active in every session — working style, identity) or a **scoped** one? Global → the scope section begins with the exact line `Scope: always` (`/setup` keys on it), and if it's the user's first/only global module, **highly recommend naming it `Core`** (the convention; the engine keys on the scope, not the name). Scoped → push for the concrete paths, repos, and contexts where it applies: a module with a vague scope silently never activates.
- One or two sentences on what the organization/context is and what the user does there.
- Any rules, facts, or guides they already know belong in it (optional — the module can start empty).

## 2. Scaffold from the template

Copy `modules/_template/` to `modules/<Name>/`, then tailor it:

- **`README.md`**: fill in what the module is, the **Activation scope** (per step 1), and the folder layout. Delete the template's instructional comments.
- **Keep only what has content now**: delete example rules files for types with no rules yet, and delete `orient.md`/`audit.md`/`setup.md` unless the user wants module-specific behavior for them (offer: an `orient.md` that surveys the org's active work, an `audit.md` that checks module content against the live environment, a `setup.md` only if the org needs environment prep).
- **Tailor `wiring/` — never leave the examples**: replace `wiring/commands/example-deliverable.md` with a real module-prefixed wrapper or delete it, and replace `wiring/hooks.json`'s example entry with a real registration or delete the file. Left verbatim, `/setup` installs a broken command (colliding across modules) and registers a hook that fails on every Write/Edit.
- Replace the template's example entries with the user's actual content, routed through the same classification and placement logic as `/add-entry`.
- Rules read imperative and person-free; identity lives in a knowledge doc. Every doc in an always-scoped module's `knowledge/` folder is read during orientation, so the README describes the folder generically rather than marking individual files.

## 3. Install and verify

Run `scripts/wire.sh` from the baseline folder — it installs any module wiring and, for a global module, wires `rules/rules-global.md` into the always-on import block. Confirm the module is gitignored (`git check-ignore modules/<Name>/README.md` matches — modules never commit).

## 4. Report back

Summarize: the module's declared scope in one line, what was scaffolded and what was deleted from the template, what was seeded, and how it will activate (always, or on which matches). Remind the user that guide commands go in `wiring/commands/` (module-prefixed, thin wrappers) and hooks in `wiring/hooks.json`, followed by a `/setup` re-run.
