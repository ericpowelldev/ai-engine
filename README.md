# AI Engine

A portable, model-agnostic engine for working with an AI agent. The scaffold ships **zero opinions**: all rules, guides, and knowledge live in **modules** you build for yourself — the baseline provides the mechanics (loading, wiring, commands) and a detailed template to build from. Claude Code is the first-class integration; the content itself is plain markdown any tool can read.

## How it works

- **Modules are the only content unit.** Each module under `modules/` is a self-contained pack — rules, guides, knowledge, scripts, hooks, wiring — with a README declaring its **activation scope**: `Scope: always` for a global module (working style, identity), or concrete paths/repos/contexts for a scoped one. Active modules compose.
- **Two loading layers keep context cheap.** Always-on: the baseline mechanics plus each global module's global rules, wired into your user-level config by setup. On-demand: typed rules load as skills generated from your rule-types registry in `registries/` (you define the types and when each fires; setup generates a skill per type your modules use), guides run as commands, knowledge loads when the work calls for it. Inventing a type is one registry line plus a rules file.
- **Modules are local.** Everything under `modules/` is gitignored except the shared template — the repo shares the engine, never your content. Each module owns its own privacy, and can be its own git repo for versioning/backup: the engine repo never sees module history, and `/pull` updates the whole family (engine + every module repo) in one motion.

## Folder map

| Path | Purpose | Committed? |
|---|---|---|
| `CLAUDE.md` | The engine's mechanics — how modules, rules, and wiring work | Yes |
| `SETUP.md` | The setup and tooling walkthrough | Yes |
| `.claude/` | Claude Code plumbing: the root commands | Yes |
| `scripts/` | Engine tooling | Yes |
| `registries/` | User-managed system-level definitions; scaffolding committed, your registries local | Scaffolding only |
| `modules/` | Your content packs, plus the committed template to copy | Template only |

## Getting started

Clone anywhere, open Claude Code inside the folder, run `/setup`. On a fresh clone it walks you through building your first modules — a global one for how you work (**highly recommended: name it `Core`** — the convention for the always-scoped module holding your non-org rules, identity, and knowledge) and a scoped one for your organization — plus seeding your rule-types registry. See `SETUP.md` for details and other tools.

## The commands

| Command | What it does |
|---|---|
| `/orient [module]` | Orient a session: refreshes the wiring first (self-healing), then loads the always-on modules and the matching scoped module, following that module's own orientation data when it has any |
| `/add-entry <entry>` | Capture a rule or fact — classifies the shape by content, places it in the owning module, reports the reasoning |
| `/add-module <name>` | Scaffold a new module from the template — scope first, then content |
| `/audit <module\|engine>` | Deep-dive audit of one target per run — asks if none given: full-content and reference integrity for a module, or `engine` for the maintainer's baseline check |
| `/rule-lookup [name\|type\|keyword]` | Look up a rule by exact name, registered type, or keyword and show its current wording; no argument prints the rule inventory |
| `/setup [module]` | Install or refresh all wiring; walks first-time users through module creation |
| `/pull` | Update everything: pull the baseline repo and every module repo (ff-only, skips dirty trees), then refresh the wiring |
| `/push [message]` | Back up the modules: commit and push each module repo's current branch; skips clean modules; never touches the baseline repo |

Modules extend `/orient`, `/audit`, and `/setup` with their own optional data files, never with commands of their own. Deliverable guides get module-prefixed command wrappers inside their module.

## Adding to it

- **A rule or fact** → `/add-entry`. An agent's session memory is only the capture layer; durable corrections graduate into a module.
- **A guide** → the owning module, plus a thin command wrapper.
- **A mechanical check** → a hook script in the owning module, registered through its wiring.
- **A new organization or context** → `/add-module`.
