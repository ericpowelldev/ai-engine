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

This is a full-content audit: **read every in-scope file completely** — for the baseline: `CLAUDE.md`, `README.md`, `SETUP.md`, the modules README, everything in `.claude/`, `scripts/`, and `registries/`, and the whole `modules/_template/`; for a module: every module file. The user's `registries/rule-types.md` is checked in **every** scope — it's system-level. Skimming disqualifies the audit — a file is only audited once it's been read to the last line. Sections 1 and 2 apply to whatever is in scope; 3–5 are baseline (engine) concerns; 6 applies to module content. **When a module is in scope and has an `audit.md` at its root, also run its checks** — org-specific audit direction lives there. Report findings; propose fixes but apply nothing without approval.

## 1. Reference integrity (the core pass)

Every pointer in every file must resolve. Check, in each file:

- **File paths** mentioned in prose (`modules/<X>/rules/rules-coding.md`, `scripts/wire.sh`, `~/.claude/...`) — the target exists.
- **Command and skill names** (`/orient`, `/add-entry`, `coding-rules`) — the wrapper/skill file exists and its frontmatter description still matches what the referencing text claims it does.
- **Named rules** cited across files (`testing-unit-only`, `documenting-fences-column-zero`) — the rule exists, in the file the reference implies, exactly once per tier.
- **Section references** ("see Sharing & Setup", "see Loading & Wiring") — the section exists in the named document.
- **Concept names** (the baseline folder, rule types, tier names) — used consistently, no orphaned terminology from earlier designs.

**Unresolved-reference protocol:** when a pointer doesn't resolve, don't guess-fix and don't silently delete. First try to infer the intended target — renamed or moved files (check git history if available), near-matching filenames, content that matches what the reference describes. If a clear candidate exists, propose it as the fix with the evidence. **If there is no clear candidate, ask the user** what the reference pointed to or where it moved — collect all such questions and ask them together, then fix per the answers.

## 2. Cross-file consistency

The same fact stated in two places must match:

- The folder map (`README.md`'s table, the folder READMEs) — same folders, same purposes, same committed/local split.
- The rule-types registry (`registries/rule-types.md`) vs. the modules' `rules-*.md` files: every used type registered, registered-but-unused types noted.
- The documented gitignore pattern vs. the actual `.gitignore` vs. the README's "Committed?" column.
- Any behavior described in two docs (setup flow, module activation, wiring install, skill generation) — descriptions agree.

## 3. Contract vs. implementation

Docs that promise behavior are checked against the code that delivers it:

- `/setup`'s end-state contract vs. what `scripts/wire.sh` actually does (install targets, manifest behavior, placeholder substitution, degradation paths).
- `SETUP.md`'s claims (OS support, uninstall steps, what gets installed) vs. the script and the manifest.
- `.claude/settings.json` hook registrations vs. the modules' `hooks/` scripts and how docs say they're registered.

## 4. Baseline creep & leaks

- `CLAUDE.md` stays thin (~80 lines); identify demotion candidates if over.
- **The baseline is content-free**: no behavioral rules, preferences, or opinions anywhere committed — mechanics and neutral template examples only.
- No user names, emails, or machine-specific paths in committed files (grep with word boundaries — avoid substring false positives).
- No specific module names in committed plumbing or docs (the template's placeholders don't count).
- Gitignore split intact: `modules/` contents ignored except the modules README and `_template/`.

## 5. Wiring health

- Installed command copies in `~/.claude/commands/` match their sources with `{{AI_DIR}}` resolved; manifest entries all point at existing files; no unresolved placeholders.
- Every root command except `setup.md` is installed; every module wiring wrapper is installed and targets an existing file.
- Generated skills in `~/.claude/skills/` match the registry exactly: one per registered type in use, none missing, none orphaned, descriptions matching the registry's triggers.

## 6. Content quality

- Rules: short, rule-shaped, imperative, domain-prefix named, one concern each; the why included only where it changes application. Fact-shaped entries belong in knowledge — flag them (and rule-shaped knowledge entries, inversely). (User-neutrality is an engine-only check — section 4; modules own their privacy.)
- **Each rule fits its file's registry trigger**: a rule sitting under a type whose `Load when:` wouldn't fire for it belongs in a different registered type — flag cross-type misfilings.
- Knowledge: fact-shaped, present tense, standalone, no war stories or status snapshots.
- **Registry triggers don't blatantly overlap**: read all `Load when:` triggers side by side and judge whether two types would fire on the same work — overlapping triggers mean double-loaded or misrouted rules.
- Structure: every module has a README whose activation scope is either the exact line `Scope: always` or concrete paths/repos/contexts; no nested `modules/` inside a module.
- **Module READMEs route generically**: routing rows point at folders and concepts, never at one specific file (a `guides/` row covers every guide in it) — flag per-file rows and file-specific entries; specifics live in the files themselves, and a README row changes only when a whole new folder or routing concept appears.
- **Modules are not a place for actual work to be stored**: a module holds process (rules, guides, knowledge, scripts, hooks, wiring) — flag any work product, work-in-progress, brainstorming, or effort folder found inside one; actual work lives in its own workspace outside the module. Exception: gitignored, regenerable output that a module's own commands generate (declared in the module README) is tool output, not work storage.
- Markdown fences at column 0 everywhere.

## Report

Findings grouped by section with severity (**fix now** / worth fixing / cosmetic), exact file and line, and the proposed fix — followed by the collected unresolved-reference questions for the user, if any. Clean sections get one line each. End with a one-line coverage statement (files read / files total). Ask before applying any fixes.
