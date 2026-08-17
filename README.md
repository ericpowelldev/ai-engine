# AI

A portable, model-agnostic home for everything that shapes how an AI agent works with you: always-on rules, on-demand rule packs, deliverable guides, reference knowledge, personal context, and organization-specific modules. Claude Code is the first-class integration; the content itself is plain markdown any tool can read.

## How it works

Two layers keep context cheap:

1. **Always-on baseline** — `CLAUDE.md` auto-loads in every session (via an import in your user-level `~/.claude/CLAUDE.md`, installed by setup). It holds only universal rules, chat/writing patterns, and the routing map. It stays thin: every line costs every session.
2. **On-demand everything else** — rule packs load automatically as skills when a task matches, guides run as commands when you ask for a deliverable, knowledge and modules load when the work calls for them.

## Folder map

| Folder | Purpose | Committed? |
|---|---|---|
| `rules/` | Short rule docs per context (`rules-coding.md`, …) | Yes |
| `hooks/` | Scripts that enforce rules mechanically | Yes |
| `guides/` | How-tos for producing common deliverables | Yes |
| `knowledge/` | General, org-agnostic reference knowledge | Yes |
| `personal/` | Who you are — identity, preferences, terminology | No (local only) |
| `scratchpad/` | Isolated brainstorming, one folder per idea | No (local only) |
| `modules/` | Self-contained organization packs | No (local only) |
| `.claude/` | Claude Code plumbing: commands, skills, hook registration | Yes |

`personal/`, `scratchpad/`, and `modules/` keep only their `README.md` in git — everything else inside them stays on your machine.

## Getting started

Clone anywhere, open Claude Code inside the folder, run `/setup`. See `SETUP.md` for details and for setting up with other tools.

## Adding to it

- **A new rule or fact** → run `/add-entry <the entry>` — it classifies the shape (rule vs. knowledge — the content decides, not how you phrased it), determines the tier (generic vs. module) and file, writes it in house style, and reports where it landed and why. Manually: rules go in the matching `rules/rules-<type>.md` (or the module's) with a domain-prefixed name (`coding-modular`); facts go in the fitting knowledge file. If a script could enforce a rule instead, write a hook.
- **A new guide** → `guides/` (or the module's), plus a thin command wrapper named for the deliverable.
- **A new organization** → run `/add-module <org>` — scaffolds the module mirror with its scope-declaring README and installs its wiring.
- **An idea with no home** → its own folder under `scratchpad/`.

Rules are the law; an agent's session memory is only the capture layer — when a correction proves durable, graduate it into a rules file.

## Modules are self-contained

Everything org-specific — rules, guides, knowledge, wiring — lives inside `modules/<Org>/` and never leaks into the root. Nothing committed here names a specific module. Import a module by dropping its folder into `modules/` and re-running `/setup`; remove it by deleting the folder and re-running `/setup`.
