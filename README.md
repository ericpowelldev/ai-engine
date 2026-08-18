# AI Engine

A portable, model-agnostic engine for working with an AI agent. The scaffold ships **zero opinions**: all rules, guides, knowledge, and scratch live in **modules** you build for yourself — the baseline provides the mechanics (loading, wiring, commands) and a detailed template to build from. Claude Code is the first-class integration; the content itself is plain markdown any tool can read.

## How it works

- **Modules are the only content unit.** Each module under `modules/` is a self-contained pack — rules, guides, knowledge, scratchpad, hooks, wiring — with a README declaring its **activation scope**: `Scope: always` for a global module (working style, identity), or concrete paths/repos/contexts for a scoped one. Active modules compose.
- **Two loading layers keep context cheap.** Always-on: the baseline mechanics plus each global module's `rules-global.md`, wired into your user-level config by setup. On-demand: typed rules load as skills **generated from your rule-types registry** (`registries/rule-types.md` — you define the types and when each fires; setup generates a skill per type your modules use), guides run as commands, knowledge loads when the work calls for it. Inventing a type is one registry line plus a rules file.
- **Modules are local.** Everything under `modules/` is gitignored except the template — the repo shares the engine, never your content. Each module owns its own privacy, and can be its own git repo for versioning/backup: the engine repo never sees module history, and `/pull` updates the whole family (engine + every module repo) in one motion.

## Folder map

| Path | Purpose | Committed? |
|---|---|---|
| `CLAUDE.md` | The engine's mechanics — how modules, rules, and wiring work | Yes |
| `.claude/` | Claude Code plumbing: commands and skills | Yes |
| `hooks/` | Engine tooling only (`setup.sh`, `pull.sh`, `push.sh`) | Yes |
| `registries/` | User-managed system-level definitions (rule types); scaffolding committed, your registries local | README + templates only |
| `modules/_template/` | The scaffold to copy for a new module, with detailed neutral examples | Yes |
| `modules/<yours>/` | Your content: rules, guides, knowledge, scratch, hooks, wiring | No (local only) |

## Getting started

Clone anywhere, open Claude Code inside the folder, run `/setup`. On a fresh clone it walks you through building your first modules — a global one for how you work (**highly recommended: name it `Core`** — the convention for the always-scoped module holding your non-org rules, identity, and knowledge) and a scoped one for your organization — plus seeding your rule-types registry. See `SETUP.md` for details and other tools.

## The commands

| Command | What it does |
|---|---|
| `/orient [module]` | Orient a session: always-on modules, then the scoped module (fuzzy-matched argument or automatic scope detection), following the module's own `orient.md` when it has one |
| `/add-entry <entry>` | Capture a rule or fact — classifies the shape by content, places it in the owning module's right file, reports the reasoning |
| `/add-module <name>` | Scaffold a new module from `modules/_template/` — scope first, then content |
| `/audit <module\|engine>` | Deep-dive audit of one target per run — asks if none given: full-content + reference integrity for a module (plus its own `audit.md` checks), or `engine` for the maintainer's baseline check |
| `/setup [module]` | Install/refresh all wiring; walks first-time users through module creation |
| `/pull` | Update everything: pull the baseline repo and every module repo (ff-only, skips dirty trees), then refresh the wiring |
| `/push [message]` | Back up the modules: commit (default message `sync: <date>`) and push each module repo's current branch; skips clean-and-synced modules; never touches the baseline repo |

Modules extend `/orient`, `/audit`, and `/setup` with data — optional `orient.md`, `audit.md`, `setup.md` files at the module root — never with commands of their own. Deliverable guides get module-prefixed command wrappers in the module's `wiring/commands/`.

## Adding to it

- **A rule or fact** → `/add-entry`. An agent's session memory is only the capture layer; durable corrections graduate into a module.
- **A guide** → the owning module's `guides/`, plus a thin command wrapper in its `wiring/commands/`.
- **A mechanical check** → a script in the module's `hooks/`, registered via its `wiring/hooks.json`.
- **A new organization or context** → `/add-module`.
