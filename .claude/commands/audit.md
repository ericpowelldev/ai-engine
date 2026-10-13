---
description: Deep-dive audit of one module (fuzzy-matched, asks if omitted) or the engine — full-content consistency, reference integrity, drift
---

Audit deeply. The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, the baseline folder is the current project root).

Scope argument: $ARGUMENTS

**Resolve the scope first:**

- **A module name** → fuzzy-match it against the `modules/` folder names — exact (case-insensitive), then prefix, then initials/abbreviation (e.g. "aw" → AcmeWidgets), then substring. Exactly one match → audit that module. Zero or multiple matches → list the modules found and ask which was meant.
- **`engine`** (or `baseline`) → audit the engine only: every committed file (including `modules/_template/`) — the baseline holds no content, so this is the maintainer's check, useful after editing engine files or before pushing the shared repo.
- **No argument** → don't default anywhere: list the auditable targets — the modules found, plus `engine` — and ask which one.

One target per run — a full-content audit of everything at once is too much scope to do well; audit targets one at a time, in separate runs.

This is a full-content audit: **read every in-scope file completely** — for the baseline: `CLAUDE.md`, `README.md`, `SETUP.md`, the modules README, everything in `.claude/`, `scripts/`, and `registries/`, and the whole `modules/_template/`; for a module: every module file, plus the rules files (rules only, not the rest of their content) of every other module, for the cross-module checks in section 6. The user's `registries/rule-types.md` is checked in **every** scope — it's system-level. Skimming disqualifies the audit — a file is only audited once it's been read to the last line. Sections 1 and 2 apply to whatever is in scope; 3–5 and 7 are baseline (engine) concerns; 6 applies to module content. **When a module is in scope and has a `content/extensions/audit.md`, also run its *Checks* section** — org-specific audit direction lives there. Report findings; propose fixes but apply nothing without approval.

## 1. Reference integrity (the core pass)

Every pointer in every file must resolve. Check, in each file:

- **File paths** mentioned in prose (`modules/<X>/content/rules/rules-coding.md`, `scripts/wire.sh`, `~/.claude/...`) — the target exists, and a path inside module content follows the content path convention in `CLAUDE.md` (*Modules*): relative to `content/`, or to the module root for a file outside it. A path that resolves only relative to its own file (`../guides/…`) is a convention finding.
- **Command and skill names** (`/orient`, `/entry`, `<type>-rules`) — the wrapper/skill file exists and its frontmatter description still matches what the referencing text claims it does.
- **Named rules** cited across files (e.g. a `<domain>-<concept>` name) — the rule exists, in the file the reference implies, exactly once per loading layer.
- **Extension files** — every `##` section in a module's `content/extensions/<name>.md` names an extension point its command or guide actually declares, and is marked adds or replaces.
- **Section references** ("see *Wiring*" in `CLAUDE.md`, "see *Uninstall*" in `SETUP.md`) — the section exists in the named document.
- **Concept names** (the baseline folder, rule types, loading layers) — used consistently, no orphaned terminology from earlier designs. Every term a rule, guide, template, or hook uses for a process artifact (a plan section, a card field, a status, a review step, a file) is defined by a current rule or guide; a term nothing defines anymore is left over from a removed process.

**Unresolved-reference protocol:** when a pointer doesn't resolve, don't guess-fix and don't silently delete. First try to infer the intended target — renamed or moved files (check git history if available), near-matching filenames, content that matches what the reference describes. If a clear candidate exists, propose it as the fix with the evidence. **If there is no clear candidate, ask the user** what the reference pointed to or where it moved — collect all such questions and ask them together, then fix per the answers.

## 2. Cross-file consistency

The same fact stated in two places must match:

- The folder map (`README.md`'s table, the folder READMEs) — same folders, same purposes, same committed/local split.
- The rule-types registry (`registries/rule-types.md`) vs. the modules' `rules-*.md` files: every used type registered, registered-but-unused types noted.
- The documented gitignore pattern vs. the actual `.gitignore` vs. the README's "Committed?" column.
- Any behavior described in two docs (setup flow, module activation, wiring install, skill generation) — descriptions agree.
- Guides, templates, and knowledge vs. the rules they apply: no guide step, template field, or knowledge statement contradicts a current rule (a status set at a different moment, a reference a rule allows but a guide forbids, a step a rule removed).
- A rule's own examples obey that rule and its sibling rules.

## 3. Contract vs. implementation

Docs that promise behavior are checked against the code that delivers it:

- `/setup`'s end-state contract vs. what `scripts/wire.sh` actually does (install targets, manifest behavior, placeholder substitution, degradation paths).
- `SETUP.md`'s claims (OS support, uninstall steps, what gets installed) vs. the script and the manifest.
- `~/.claude/settings.json` hook registrations vs. the modules' `wiring/hooks/` scripts and how docs say they're registered.
- In a module audit, the module's scripts and hooks vs. the guides and rules that describe them: each does what the docs claim (what it keeps, skips, refuses, or writes), and the docs claim nothing it doesn't do.

## 4. Baseline creep & leaks

- `CLAUDE.md` stays thin (~80 lines); identify demotion candidates if over.
- **The baseline is content-free**: no behavioral rules, preferences, or opinions anywhere committed — mechanics and neutral template examples only.
- No user names, emails, or machine-specific paths in committed files (grep with word boundaries — avoid substring false positives).
- No specific module or rule names in committed plumbing or docs (the template's placeholders and the recommended `Core` naming convention don't count).
- Gitignore split intact: `modules/` contents ignored except the modules README and `_template/`.
- **Engine READMEs stay one layer deep**: `README.md`, `modules/README.md`, and `modules/_template/README.md` each describe only their immediate top-level structures — no references into subfolders' contents, no reproduced module-internal file trees; the detail lives in the nested READMEs and `_template/`.

## 5. Wiring health

- Installed command copies in `~/.claude/commands/` match their sources with `{{AI_DIR}}` resolved; manifest entries all point at existing files; no unresolved placeholders.
- Every root command except `setup.md` is installed; every module wiring wrapper is installed and targets an existing file.
- Generated skills in `~/.claude/skills/` match the registry exactly: one per registered type in use, none missing, none orphaned, descriptions matching the registry's triggers.
- Every interpreter a hook or the wiring script runs (`python`, `node`, …) works in this machine's environment, not just resolves to a name: a placeholder or missing interpreter makes a hook fail open silently. Run each hook once with a sample payload.

## 6. Content quality

- Rules: named sections (`## <domain>-<concept>`, or `<domain>-<category>-<concept>` in a file that names its categories), each opening with a brief, rule-shaped, imperative statement, one concern each; detail below the statement only where the rule needs it, and the why only where it changes application; always-on files hold statements only. Fact-shaped entries belong in knowledge — flag them (and rule-shaped knowledge entries, inversely). (User-neutrality is an engine-only check — section 4; modules own their privacy.)
- **Rule names and categories**: every rule name is unique across all modules. A rules file that uses categories (`<domain>-<category>-<concept>`) names them in its intro, and every rule in it uses one of them. A category is a concept (structure, naming, workflow), never a module's or organization's name.
- **No duplicate or pointer-only rules**: flag a rule that says what another rule already says, in the same module or across modules (propose merging into one, keeping any detail only one of them has), and a rule whose body is only pointers to other rules (propose removing it).
- **Docs point, never restate**: a guide or knowledge doc names the rules it follows instead of copying them. Flag copied rule wording, and any count, list, or format repeated from a rule ("the four knowledge files", a copied line format), or from a script that owns it (a guide's manual fallback copying a script's constants): each goes stale the moment its source changes.
- **Command wrappers are thin**: a module's `wiring/commands/` file points at a guide in `content/guides/` and carries no procedure of its own; a procedure living in a wrapper belongs in a guide, so it stays agent-agnostic.
- **Graduation candidates**: in a scoped module, flag rules general enough for the always-scoped module: language-agnostic, safe in any codebase without fighting its conventions, and a principle rather than a taste. Inversely, flag always-scoped rules that are really specific to one organization, language, or framework.
- **Each rule fits its file's registry trigger**: a rule sitting under a type whose `Load when:` wouldn't fire for it belongs in a different registered type — flag cross-type misfilings.
- Knowledge: fact-shaped, present tense, standalone, no war stories or status snapshots.
- **Registry triggers don't blatantly overlap**: read all `Load when:` triggers side by side and judge whether two types would fire on the same work — overlapping triggers mean double-loaded or misrouted rules.
- Structure: every module has a README whose activation scope is either the exact line `Scope: always` or concrete paths/repos/contexts; no nested `modules/` inside a module.
- **Module READMEs stay one layer deep**: the module's README names and explains only its top-level folders — never referencing deeper than that one layer, never enumerating or explaining the contents inside them (a `content/` row covers every rule, guide, and knowledge doc in it; each file owns its own detail). Flag deep references (a `content/rules/rules-global.md` pointer, a `wiring/commands/…` path), per-file routing rows, and content enumeration; a README row changes only when a whole new top-level folder appears.
- **Modules hold process, not project specifics**: a module's knowledge and rules describe how the user works and cross-project process — identity, glossaries, conventions, reference the module owns. Flag knowledge or rules that document one particular external project (its design, canon, architecture, paths, or domain); that belongs in the project itself (its own docs or its instruction file), not the module.
- **Modules are not a place for actual work to be stored**: a module holds process (its content, scripts, and wiring) — flag any work product, work-in-progress, brainstorming, or effort folder found inside one; actual work lives in its own workspace outside the module. Exception: gitignored, regenerable output that a module's own commands generate (declared in the module README) is tool output, not work storage.
- Markdown fences at column 0 everywhere.

## 7. Template fidelity

`modules/_template/` is what every new module starts from, so it must be both generic and a faithful, working model of a real module. In an engine audit, also list the local modules' top-level files and folders (names only, not their content) to compare shapes against.

- **Generalized**: no user, organization, product, or project names anywhere in it, and no module's actual content. Every example is a neutral sample marked as one (`<placeholder>` text, or "Example entries (replace with your own)"), and no example encodes one user's process as the default: an example rule should be one most users could adopt, never one that argues for a particular workflow.
- **Represents a real module**: every kind of item the local modules commonly carry has a template counterpart: the README, `.gitignore`, each `content/` folder (rules, guides, knowledge, extensions), `scripts/`, and `wiring/` (commands, `hooks.json`, hook scripts). A kind of item that appears in two or more local modules but not in the template is a gap; propose a placeholder for it. Conversely, the template holds nothing the engine doesn't support.
- **Self-consistent and runnable**: every reference inside the template resolves inside the template (the example command's guide, `hooks.json`'s hook script). Example scripts and hooks pass a syntax check, and the example hook exits 0 on a sample payload; JSON files parse. `_template` stays excluded from wiring (`scripts/wire.sh` skips it), so its examples never install.
- **Demonstrates the engine's conventions**: rule headings follow the naming in `CLAUDE.md` (*Rule types*), with at least one rules file demonstrating categories; always-on rules files (`rules-global.md`, the agent rules) hold statements only; extension files name only extension points their commands declare (`/orient`, `/audit`, `/setup`), each marked adds or replaces; the example guide declares extension points the way guides do; paths follow the content path convention; READMEs stay one layer deep; fences sit at column 0.
- **Matches the registry template**: the template's example rules files are exactly the types `registries/rule-types.template.md` lists (reserved types included), so a fresh setup has a rules file to copy for each.
- **Matches `/module`**: every file in the template is one `/module` tells the user to fill in, keep, or delete when unused, and `/module` names no file the template lacks.
- **Matches what the engine docs say about it**: `README.md`, `modules/README.md`, and `SETUP.md` describe the template (a detailed scaffold with examples for every file); those descriptions still hold.

## Report

Findings grouped by section with severity (**fix now** / worth fixing / cosmetic), exact file and line, and the proposed fix — followed by the collected unresolved-reference questions for the user, if any. Clean sections get one line each. A check that needs an environment this machine lacks (a workspace, a repo, a service) is reported as **not run**, with where it can run. Then the **audit's own gaps** (see below). End with a one-line coverage statement (files read / files total). Ask before applying any fixes.

## Keeping this command current

This command audits the system as it stands, so it changes whenever the system does. It grows as the system grows: completeness matters more than brevity, and staleness is the failure to prevent.

- **When the baseline or module structure changes** (a new naming convention, folder, file type, extension point, or a removed process), update this command in the same change, so the next audit checks the new shape and stops checking the old one, and update `modules/_template/` (and `/module`) so new modules start from the new shape.
- **Every audit ends with its own gaps**: after the findings, list any class of finding this checklist didn't name (something caught by judgment rather than by a check) and propose the line to add, here for engine-wide mechanics or in the module's `content/extensions/audit.md` for that module's own conventions. The engine stays content-free: a check that encodes one user's preferences goes in their module's extension, never here.
