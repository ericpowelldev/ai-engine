# Setup

How to wire this folder into your environment.

## Claude Code (one command)

1. Clone this repo anywhere — nothing assumes a fixed path.
2. Open Claude Code inside the cloned folder.
3. Run `/setup`.

`/setup` is idempotent — re-run it after a `git pull` or after adding/removing a module. By default (or with `all`) it covers the baseline **and** every module present; an optional fuzzy module argument (`/setup hd`) focuses a run on one module — its validation and any `setup.md` it ships — without narrowing the mechanical sync.

## OS support

Works on **macOS, Linux, and Windows**. The design is agent-first: `/setup` defines the end state, and the agent guarantees it — `hooks/setup.sh` is just the fast path (bash + coreutils, available everywhere Claude Code runs, including Git Bash on Windows). Anything the script can't do on a given machine (e.g. the `settings.json` merge needs `python3`, which Git Bash lacks), the agent performs directly with its own file tools. The fence-check hook is pure coreutils and registered as `bash "<path>"` so it runs regardless of the OS shell.

### What it does

- Runs `hooks/setup.sh` for the mechanical steps:
  - Adds an import of this folder's `CLAUDE.md` to your user-level `~/.claude/CLAUDE.md` (merging, never overwriting), so the baseline loads in every session no matter where it boots.
  - Installs the global `/orient` command into `~/.claude/commands/`.
  - Installs the rule skills into `~/.claude/skills/` so they fire in sessions booted outside this folder.
  - Registers the hooks (e.g. the markdown fence check) in `~/.claude/settings.json`.
  - Syncs each present module's `wiring/` contents (commands, skills, hook registrations) into `~/.claude/` — user-level only, so the committed `.claude/` stays module-agnostic.
- Then guides personalization:
  - Asks about you to seed `personal/` (local only, never committed).
  - Writes any user-specific always-on rules into your user-level `~/.claude/CLAUDE.md`, keeping the committed baseline user-neutral.
  - Offers to create your first module.

## Other agents / tools

Give your agent this prompt:

> Read SETUP.md and CLAUDE.md in this folder, then configure my environment so the baseline loads in every session and the rules/guides load on demand, using this tool's equivalent of global config, skills, and commands.

The content is plain markdown; only the plumbing under `.claude/` is Claude-specific. A tool that wants its own entry file (e.g. `AGENTS.md`) gets a thin pointer to `CLAUDE.md` — content never moves.

## Uninstall

Delete every path listed in `~/.claude/.ai-wiring-manifest` (the exact record of what setup installed), then the manifest itself, the import line in `~/.claude/CLAUDE.md`, and the fence-check hook entry in `~/.claude/settings.json`. Then delete the clone. Modules and `personal/` content are local to your machine — copy them out first if you want to keep them.
