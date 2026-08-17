---
description: Initialize or refresh this baseline folder's wiring in the user's environment
---

Set up (or refresh) this baseline folder in the user's environment. Idempotent — welcome re-runs after a `git pull` or after adding/removing a module. Works on macOS, Linux, and Windows: a script provides the fast path, but **you own the end state** — whatever the script can't do on this machine, do yourself with your own file tools.

Optional module argument: $ARGUMENTS

- **No argument, or `all`** → the default: set up the baseline and every module present.
- **A module name** → fuzzy-match it against the `modules/` folder names — exact (case-insensitive), then prefix, then initials/abbreviation (e.g. "hd" → HopDrive), then substring. Exactly one match → focus this run on that module: the mechanical sync still runs in full (it's idempotent and covers everything anyway), but validation, module-specific setup, and the report center on the resolved module. Zero or multiple matches → list the modules found and ask which was meant.

## The end state (the contract)

1. The user-level `~/.claude/CLAUDE.md` contains an import line pointing at this folder's `CLAUDE.md` (its absolute path), exactly once, with all pre-existing content untouched.
2. Every root command except `setup.md` is installed to `~/.claude/commands/`, and every skill in `.claude/skills/` to `~/.claude/skills/`, with the `{{AI_DIR}}` placeholder replaced by this folder's absolute path.
3. `~/.claude/settings.json` registers the fence-check hook — PostToolUse, matcher `Write|Edit`, command `bash "<this folder>/hooks/check-markdown-fences.sh"` — exactly once, with all other settings preserved.
4. Each present module's `wiring/commands/` and `wiring/skills/` contents are installed to `~/.claude/`, placeholders resolved; wiring from removed modules is gone.

## How to get there

1. **Try the fast path**: run `bash hooks/setup.sh` from this folder and report what it did. It maintains an install manifest (`~/.claude/.ai-wiring-manifest`) that prunes stale wiring — preserve that behavior.
2. **Fill any gaps yourself**: if the script fails, is skipped, or reports a SKIPPED step (e.g. no `python3` for the settings.json merge), achieve the same end state directly — read, copy, and edit the files with your own tools, substituting `{{AI_DIR}}` as you go, and append installed paths to the manifest. Editing `settings.json` yourself: merge into the existing JSON, never overwrite the file.
3. **Verify**: confirm the import line appears exactly once, spot-check one installed command and one skill for a resolved placeholder, and confirm the hook entry exists once.
4. **Validate each module in scope** (the targeted module, or all of them on a default run): its `README.md` exists and declares a **concrete activation scope** (real paths/repos/contexts — a vague scope means the module silently never activates); it contains no `personal/` folder and no nested `modules/`; and every wrapper in its `wiring/commands/` points at a file that exists. Warn about anything malformed and offer to fix it — a freshly imported module is caught here, at import time, rather than at the next `/audit`.
5. **Module-specific setup**: if a module in scope has a `setup.md` at its root, follow it — org-specific setup direction (environment prep, credentials pointers, extra wiring) lives there, not in this command.

## Personalize (first run only — skip if `personal/` already has content)

- Ask the user about themselves — role, what they work on, how they like to work, terminology — and seed `personal/about.md` (and `personal/terminology.md` if they gave terms).
- Ask whether they have user-specific always-on rules; write those into `~/.claude/CLAUDE.md` below the import (the committed baseline stays user-neutral).
- Offer to create their first module via `/add-module`.

## Confirm

Summarize what is now wired up, note anything done manually versus by the script, and suggest `/orient` as the way to start any session.
