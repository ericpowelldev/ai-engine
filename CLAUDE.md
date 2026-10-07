# AI Baseline

This folder — the **baseline folder**, wherever it lives and whatever it's named — is the engine of a modular rules system for working with an AI agent. The baseline itself carries **no content and no opinions**: all rules, guides, and knowledge live in **modules**, and this file only defines how the system works. Follow these mechanics in every session.

## Modules

A module is a self-contained pack under `modules/<Name>/` holding an organization's or context's content and tooling, in one fixed layout:

- **`content/`**: the agent-agnostic content: `rules/`, `guides/`, `knowledge/`, and `extensions/` (see *Wiring*). Paths written inside content are relative to `content/` (`knowledge/x.md` means `content/knowledge/x.md`), with two exceptions: a path naming a file in another module, or in this module outside `content/`, is relative to that module's root (`modules/<Name>/`), and a path describing the folder a guide works in (such as a workstream's `knowledge/decisions.md`) is relative to that folder.
- **`scripts/`**: tooling the guides call.
- **`wiring/`**: the agent-specific adapter: command wrappers, hook registrations (`hooks.json`), and the hook scripts in `wiring/hooks/`.

Each module's `README.md` is its entry point and declares its **activation scope**:

- **`Scope: always`** — a global module, active in every session (working style, cross-context rules, the user's identity).
- **Concrete paths/repos/contexts** — the module activates when the work matches.

Multiple modules are active at once: every always-scoped module plus any scope-matched one. Their content composes; on conflict, the more specifically-scoped module wins for its own work. **Before starting work, identify the active modules** — read each always-scoped module's README (plus its knowledge docs) and check the scoped modules for a match; read a matching module's README first and follow its layout.

`modules/_template/` is the committed scaffold: copy it (via `/module`) to build a new module. Everything else under `modules/` is gitignored — modules are local and own their own privacy.

## Rule types

Rule types are **user-defined in the rule-types registry** (`registries/rule-types.md`): one line per type with its load trigger. The engine ships no types of its own — `registries/` holds the committed scaffolding (README + template) while the real registry stays local.

- **Typed** rules load on demand: `/setup` generates one skill per registered type that some module actually uses; the skill's trigger is the registry's `Load when:` text, and its body reads `content/rules/rules-<type>.md` from **every active module**. Contexts compose — work matching two triggers loads both types. Minting a new type = one registry line + a rules file + a `/setup` re-run.
- **`global`** is a reserved type — mechanism, not vocabulary: each always-scoped module's `content/rules/rules-global.md` is wired into the agent's always-on layer by `/setup` (for Claude, the user-level `~/.claude/CLAUDE.md`), loading with every session; never skill-generated.
- **Agent rules** are reserved types too, one per brand of agent (`rules-claude.md`, `rules-grok.md`, …): anything specific to that agent, such as its models, dispatch, instruction file, and launcher. Only always-scoped modules carry them; each agent's adapter loads its own file in every session, and the registry lists the type as `Reserved:`. Their rule names take the agent's prefix (`claude-<concept>`). Agent-specific mechanics live only here and in the adapter: other content stays agent-agnostic.
- **Rules files are named sections.** Each rule is a `## <domain>-<concept>` heading, so it can be referred to directly, followed by a brief statement of what the rule is: its contract. Detail below the statement (examples, tables, exceptions) is optional and as long as the rule needs. One concern per rule. Always-on rules (global and agent rules) carry their statement only, since they load in every session.

## Capture flow

An agent's session memory is only the capture layer. Durable content graduates into a module via `/entry` (classifies rule vs. knowledge by the content's shape, places it in the owning active module) — and `/module` when no module fits.

## Wiring

- **Commands own procedures; modules extend them.** A command or guide declares the few parts a module may extend, its **extension points**. A module extends one with `content/extensions/<name>.md`: one `##` section per extension point it changes, each marked adds or replaces. Every active module's additions apply; when two modules replace the same point, the more specifically-scoped module wins. `/orient`, `/audit`, and `/setup` take an optional fuzzy module argument and follow the modules' `orient.md`/`audit.md`/`setup.md` extensions when present.
- **Guides run as commands:** a thin wrapper in the owning module's `wiring/commands/`, named for what the guide produces. A module's README states its command prefix, or that it has none.
- **Hooks** enforce rules mechanically: a module registers its hook scripts via `wiring/hooks.json`; the root `scripts/` folder holds only engine tooling (`wire.sh`, `pull.sh`, `push.sh`).
- `/setup` installs and refreshes everything (see `SETUP.md`); `/pull` updates the baseline and every module repo, then refreshes the wiring; `/push` commits and pushes the module repos (never the baseline); `/orient` re-orients a session, running the wiring refresh first so every session self-heals — do its steps on the first message of a session when the work isn't already stated.
- **Content is agent-agnostic; the adapter is per agent.** Claude's adapter is `.claude/`, each module's `wiring/`, the generated skills, and the user-level import, all installed by `scripts/wire.sh`; another agent gets its own adapter built from the same content. Module wiring is installed to the user level and never committed here.
