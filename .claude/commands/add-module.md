---
description: Scaffold a new self-contained organization module under modules/ and install its wiring
---

Create a new module. The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, the baseline folder is the current project root).

The organization: $ARGUMENTS

If no name was given, ask for it. Then:

## 1. Gather what the scaffold needs

Ask the user (in one round of questions, skipping anything already stated):

- **Activation scope** — the paths, repos, and contexts where this module applies. This is the most important answer: a module with a vague scope never loads. Push for concrete paths/patterns.
- One or two sentences on what the organization is and what the user does there.
- Any rules, facts, or guides they already know belong in it (optional — the module can start empty).

## 2. Scaffold

Create `modules/<Org>/` with the standard mirror — `rules/`, `guides/`, `knowledge/`, `scratchpad/`, `hooks/`, `wiring/commands/` — and:

- **`README.md`** (the module's entry point): what the org is, an **Activation scope** section listing the concrete paths/repos/contexts, and a routing table into the module's folders (mirror the shape of an existing module's README if one exists).
- **Offer the standard instruction files**: an `orient.md` (module-specific orientation — load the module, survey the org's active work, ask what to work on; followed by `/orient <org>` or on scope match) and an `audit.md` (module-specific checks against the org's live environment; run by `/audit <org>`), both at the module root. Model them on an existing module's files if any exist. Offer a `setup.md` too only if the org needs environment prep (run by `/setup`). These are plain instruction docs — modules extend the generic commands with data, never with commands of their own.
- Seed `rules/rules-<type>.md` files only for types that have rules now; don't create empty placeholders.
- Route anything the user supplied in step 1 through the same classification and placement logic as `/add-entry`.
- Everything user-neutral — the user is named only in `personal/`.

## 3. Install and verify

Run `hooks/setup.sh` from the baseline folder to install any module wiring, and confirm the module is gitignored (`git check-ignore modules/<Org>/README.md` should match the modules pattern — module contents never commit).

## 4. Report back

Summarize: the module's declared scope in one line, what was scaffolded, what was seeded, and remind the user that module guide commands go in `wiring/commands/` (module-prefixed, thin wrappers) followed by a `/setup` re-run.
