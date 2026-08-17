# hooks/

Scripts for anything mechanically checkable or reproducible. A hook replaces a written rule wherever possible: instructions decay under long context, scripts don't.

## Contents

- `check-markdown-fences.sh` — PostToolUse hook: flags indented code fences after any write to a `.md` file (enforces `documenting-fences-column-zero`).
- `setup.sh` — the mechanical half of `/setup`: installs the baseline import, global command, skills, hook registrations, and module wiring. Idempotent.

## Conventions

- Scripts live here; the registration that makes them execute lives in `.claude/settings.json` (and `~/.claude/settings.json` for global coverage, written by `setup.sh`).
- Hooks read the Claude Code hook JSON from stdin; exit code 2 with a stderr message feeds the finding back to the agent.
- Keep hooks fast and side-effect-free — they run on every matching tool call.
- Module-specific hooks ship in the module's `wiring/` and are registered by `setup.sh`.
