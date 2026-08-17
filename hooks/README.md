# hooks/

**Engine tooling only.** This folder holds scripts that make the scaffold itself work — nothing that enforces content rules.

## Contents

- `setup.sh` — the mechanical half of `/setup`: writes the always-on import block, installs commands/skills, syncs module wiring, registers module hooks, maintains the install manifest. Idempotent.
- `pull.sh` — the mechanical half of `/pull`: pulls the baseline repo and every module repo (ff-only; skips repos with uncommitted changes or no remote), then runs `setup.sh` so pulled wiring and rules take effect.
- `push.sh` — the mechanical half of `/push`: commits (message argument, default `sync: <date>`) and pushes every module repo's current branch; pushes clean-but-ahead modules, skips clean-and-synced ones, sets the upstream on a first push. Never force, never the baseline repo — engine commits are hand-written.

## Where content hooks live

Scripts that mechanically enforce a module's rules belong in that module's `hooks/` folder, registered via its `wiring/hooks.json` — `setup.sh` merges those registrations into `~/.claude/settings.json` (entries: `{event, matcher, command}`, with `{{AI_DIR}}` resolved to the baseline folder's absolute path). Hooks read the Claude Code hook JSON from stdin; exit code 2 with a stderr message feeds the finding back to the agent. Keep them fast, side-effect-free, and coreutils-only so they run on macOS, Linux, and Git Bash on Windows.
