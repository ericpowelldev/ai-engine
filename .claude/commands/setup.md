---
description: Initialize or refresh this baseline folder's wiring in the user's environment
---

Set up (or refresh) this baseline folder in the user's environment. Idempotent — welcome re-runs after a `git pull` or after adding/removing a module. Works on macOS, Linux, and Windows: a script provides the fast path, but **you own the end state** — whatever the script can't do on this machine, do yourself with your own file tools.

Optional module argument: $ARGUMENTS

- **No argument, or `all`** → the default: set up the baseline and every module present.
- **A module name** → fuzzy-match it against the `modules/` folder names — exact (case-insensitive), then prefix, then initials/abbreviation (e.g. "aw" → AcmeWidgets), then substring. Exactly one match → focus this run on that module: the mechanical sync still runs in full (it's idempotent and covers everything anyway), but validation, module-specific setup, and the report center on the resolved module. Zero or multiple matches → list the modules found and ask which was meant.

## The end state (the contract)

1. The user-level `~/.claude/CLAUDE.md` contains the managed import block (between `<!-- ai-baseline:start -->` and `<!-- ai-baseline:end -->`): an import of this folder's `CLAUDE.md` plus one import per always-scoped module's `rules/rules-global.md` (a module is always-scoped when its README's scope section begins with the exact line `Scope: always`). Exactly one block, all pre-existing content untouched.
2. Every root command except `setup.md` is installed to `~/.claude/commands/` with the `{{AI_DIR}}` placeholder replaced by this folder's absolute path, and `~/.claude/skills/` contains **one generated skill per rule type that is both registered in `registries/rule-types.md` and used by some module's `rules-<type>.md`**, each description matching the registry's trigger.
3. `~/.claude/settings.json` registers every entry from every module's `wiring/hooks.json` (placeholders resolved), exactly once each, with all other settings preserved; hooks from removed modules are unregistered.
4. Each present module's `wiring/commands/` and `wiring/skills/` contents are installed to `~/.claude/`, placeholders resolved; wiring from removed modules is gone. (`_template` is never installed.)

## How to get there

1. **Populate the registry**: scan every module's `rules/` for `rules-<type>.md` files whose type has no entry in `registries/rule-types.md` (`global` is reserved and never registered). For each, read the rules file and the owning module's README for context, then append a registry line in the house style with an inferred `Load when:` trigger. Report every inferred line verbatim so the user can reword a thin guess.
2. **Try the fast path**: run `bash scripts/wire.sh` from this folder and report what it did. It maintains an install manifest (`~/.claude/.ai-wiring-manifest`) that prunes stale wiring — preserve that behavior.
3. **Fill any gaps yourself**: if the script fails, is skipped, or reports a SKIPPED step (e.g. no `python3` for the settings.json merge), achieve the same end state directly — read, copy, and edit the files with your own tools, substituting `{{AI_DIR}}` as you go, and append installed paths to the manifest. Editing `settings.json` yourself: merge into the existing JSON, never overwrite the file.
4. **Verify**: confirm the import block appears exactly once with the expected imports, spot-check one installed command and one skill for a resolved placeholder, and confirm the hook entries match the modules' `hooks.json` files.
5. **Validate each module in scope** (the targeted module, or all of them on a default run): its `README.md` exists and declares a valid activation scope — either the exact line `Scope: always` or concrete paths/repos/contexts (a vague scope means the module silently never activates); it contains no nested `modules/`; and every wrapper in its `wiring/commands/` points at a file that exists. Also surface the script's registry warnings: a rules file whose type isn't registered (step 1 should have caught it — if the warning still fires, resolve it now), a registered type with no rules files (info), a missing registry when typed files exist. Warn about anything malformed and offer to fix it — a freshly imported module is caught here, at import time, rather than at the next `/audit`.
6. **Module-specific setup**: if a module in scope has a `setup.md` at its root, follow it — org-specific setup direction (environment prep, credentials pointers, extra wiring) lives there, not in this command.

## First run: build the first modules

If `modules/` contains nothing but `_template/`, the system has no content yet — walk the user through creating it:

1. Explain the model in two sentences: all rules and knowledge live in modules; the baseline is just the engine.
2. Offer to create their first module via `/add-module`: a **global** module (`Scope: always`) for their working style and identity — **highly recommend naming it `Core`** (the convention; the engine keys on the scope, not the name) — seeded from a short conversation about how they like to work.
3. Seed `registries/rule-types.md` from `registries/rule-types.template.md` as part of that conversation: which kinds of work do they want rules for, and when should each load?
4. Offer a **scoped** module for their organization or main context, if they have one.
5. Re-run the mechanical steps afterward so the new modules' wiring, global rules, and generated skills are installed.

## Confirm

Summarize what is now wired up (imports, commands, skills, hooks, per module), note anything done manually versus by the script, and suggest `/orient` as the way to start any session.
