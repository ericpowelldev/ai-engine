---
description: Orient (or re-orient) the session — always-on modules plus the relevant scoped module; optionally target a module by name (fuzzy — initials or partial names match)
---

Orient yourself. The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, you are booted inside the baseline folder itself — it is the current project root).

Optional module argument: $ARGUMENTS

1. **Refresh the wiring**: run `bash {{AI_DIR}}/scripts/wire.sh` (idempotent; keeps every session self-healing). If it warns about unregistered rule types, resolve them per the registry-population step in `{{AI_DIR}}/.claude/commands/setup.md`, then re-run the script.
2. **Baseline mechanics**: read the baseline folder's `CLAUDE.md` (skip only when its content is visibly present in the current context; it normally loads via the user-level import, but compaction can drop it mid-session).
3. **Always-scoped modules**: for each module under `modules/` whose README declares `Scope: always` (skip `_template`), read its `README.md`, every doc in its `knowledge/` folder, and its `rules/rules-global.md` (the global rules normally arrive via the user-level import, but re-reading them keeps re-orientation bulletproof when early context has been compacted).
4. **Understand the working directory**: when the session sits inside a repo or project folder rather than the baseline itself, read its entry-point documentation before going further: the root `CLAUDE.md` and `README.md`, plus any docs they route to that explain what this place is. Cover any additional working directories the same way. Skip docs whose content is already visible in the current context. This grounds the rest of orientation (scope matching, the report) in what this place actually is.
5. **Resolve the scoped module**:
   - **Argument given**: fuzzy-match it against the `modules/` folder names — exact (case-insensitive), then prefix, then initials/abbreviation (e.g. "aw" → AcmeWidgets), then substring. Exactly one match → use it. Zero or multiple matches → list the modules found and ask which was meant. An argument matching an always-scoped module resolves to no scoped module: re-read that module (step 3) and continue.
   - **No argument**: check each scoped module's declared scope against the current working directory and any work already underway in the session. Every matching module is active (its rules and knowledge apply); when more than one matches, the module matching most specifically owns steps 6 and 7, and the report's Modules line names them all. No match → no scoped module.
6. **Module orientation**: if the module owning the flow has an `orient.md` at its root, **follow it now**: it supplies the module's data for this flow (knowledge to always load, a work survey, the session menu). Otherwise read the module's `README.md` and note its layout, loading rules/knowledge only as the work calls for them.
7. **Close with the orientation report** (defined below): every path ends with it.

## Orientation report

Every orientation, on every path, ends by rendering this structure as the closing message. Nothing about the orientation is reported outside it: no prose before the header, no commentary after the tail.

```markdown
## Oriented

|  |  |
| --- | --- |
| 🧩 **Modules** | <always-scoped modules> + <each matched scoped module> (matched: <one-line reason>), or "+ no scoped module" |
| 📁 **Directory** | <the working directory and what it is, per its own docs>, or "the baseline folder" |

📚 **Loaded rules**

- `<rule-name>` (one bullet per loaded rule, names only, no descriptions: the global rules from each always-scoped module, plus any typed rules already triggered)

- ❌ <error>
- ⚠️ <warning>
- ℹ️ <note>

<tail>
```

The table is fixed: always these two rows, in this order, one line per cell. The loaded-rules list follows it, always present, one rule name per bullet.

The diagnostics list carries everything the table rows don't, one icon-prefixed sentence per item, ordered worst-first:

- **❌ Error** — an orientation step failed or couldn't complete (wiring script failed, a doc was unreadable, a registry warning couldn't be resolved). State what failed and what was skipped because of it.
- **⚠️ Warning** — something intact but likely to affect the session (overlapping module scopes, a doc contradicting another, missing entry-point documentation).
- **ℹ️ Note** — context worth surfacing that fits no table row (additional working directories and the modules they would activate, tooling quirks noticed on the way).

Omit the list entirely when there is nothing to report; never pad it with filler.

Only the tail varies, on whether the session already has work underway:

- **No work underway** (fresh session): the tail is the session question — ask what we are working on together, and let the next prompt state the work. A scoped module's `orient.md` supplies the menu and owns its formatting; with no scoped module, ask plainly.
- **Work underway** (re-orienting mid-session): the tail confirms the in-flight work in a sentence and hands the turn back to it; don't re-ask the session question.

Either way, orientation never takes a work statement itself — its only argument is a module name. Work enters a session through prompts, never through orient.

Questions that interrupt orientation itself (module disambiguation in step 5) come before the report; the report renders once orientation completes.
