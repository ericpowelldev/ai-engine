# hooks/

**Engine tooling only.** This folder holds scripts that make the scaffold itself work — nothing that enforces content rules.

## Contents

- `setup.sh` — the mechanical half of `/setup`: writes the always-on import block, installs commands/skills, syncs module wiring, registers module hooks, maintains the install manifest. Idempotent.

## Where content hooks live

Scripts that mechanically enforce a module's rules belong in that module's `hooks/` folder, registered via its `wiring/hooks.json` — `setup.sh` merges those registrations into `~/.claude/settings.json` (entries: `{event, matcher, command}`, with `{{AI_DIR}}` resolved to the baseline folder's absolute path). Hooks read the Claude Code hook JSON from stdin; exit code 2 with a stderr message feeds the finding back to the agent. Keep them fast, side-effect-free, and coreutils-only so they run on macOS, Linux, and Git Bash on Windows.
