# Setup

How to wire this folder into your environment.

## Claude Code (one command)

1. Clone this repo anywhere — nothing assumes a fixed path.
2. Open Claude Code inside the cloned folder.
3. Run `/setup`.

`/setup` is idempotent — re-run it after pulling or after adding/removing a module (or just use `/pull`, which pulls the baseline repo and every module repo ff-only, then re-runs setup automatically). By default (or with `all`) it covers the baseline **and** every module present; an optional fuzzy module argument (`/setup hd`) focuses a run on one module — its validation and any `setup.md` it ships — without narrowing the mechanical sync. On a fresh clone with no modules yet, it walks you through building your first ones from `modules/_template/`.

## OS support

Works on **macOS, Linux, and Windows**. The design is agent-first: `/setup` defines the end state, and the agent guarantees it — `hooks/setup.sh` is just the fast path (bash + coreutils, available everywhere Claude Code runs, including Git Bash on Windows). Anything the script can't do on a given machine (e.g. the `settings.json` merge needs `python3`, which Git Bash lacks), the agent performs directly with its own file tools. The fence-check hook is pure coreutils and registered as `bash "<path>"` so it runs regardless of the OS shell.

### What it does

- Runs `hooks/setup.sh` for the mechanical steps:
  - Writes the managed **always-on import block** into your user-level `~/.claude/CLAUDE.md` (merging, never overwriting): this folder's `CLAUDE.md` plus each global module's (`Scope: always`) `rules/rules-general.md` — so the mechanics and your always-on rules load in every session no matter where it boots.
  - Installs the root commands and rule skills into `~/.claude/` so they work in sessions booted anywhere.
  - Syncs each present module's `wiring/` — commands and skills into `~/.claude/`, and every `wiring/hooks.json` entry into `~/.claude/settings.json` — all manifest-tracked, so removed modules clean up. The committed `.claude/` stays module-agnostic.
- On a first run (no modules besides `_template/`), walks you through creating your first modules via `/add-module`: a global one for your working style and identity, and a scoped one for your organization if you have one.

## Other agents / tools

Give your agent this prompt:

> Read SETUP.md and CLAUDE.md in this folder, then configure my environment so the baseline loads in every session and the rules/guides load on demand, using this tool's equivalent of global config, skills, and commands.

The content is plain markdown; only the plumbing under `.claude/` is Claude-specific. A tool that wants its own entry file (e.g. `AGENTS.md`) gets a thin pointer to `CLAUDE.md` — content never moves.

## Uninstall

Delete every path listed in `~/.claude/.ai-wiring-manifest` (the exact record of what setup installed), then the manifest itself, the managed import block in `~/.claude/CLAUDE.md` (between the `ai-baseline` markers), and any hook entries in `~/.claude/settings.json` whose command points into this folder. Then delete the clone. Your modules are local to your machine — copy them out first if you want to keep them.
