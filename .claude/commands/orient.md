---
description: Orient (or re-orient) the session — always-on modules plus the relevant scoped module; optionally target a module by name (fuzzy — initials or partial names match)
---

Orient yourself. The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, you are booted inside the baseline folder itself — it is the current project root).

Optional module argument: $ARGUMENTS

1. **Refresh the wiring**: run `bash {{AI_DIR}}/scripts/wire.sh` (idempotent; keeps every session self-healing). If it warns about unregistered rule types, resolve them per the registry-population step in `{{AI_DIR}}/.claude/commands/setup.md`, then re-run the script.
2. **Baseline mechanics**: read the baseline folder's `CLAUDE.md` (skip only when its content is visibly present in the current context; it normally loads via the user-level import, but compaction can drop it mid-session).
3. **Always-scoped modules**: for each module under `modules/` whose README declares `Scope: always` (skip `_template`), read its `README.md`, the knowledge docs its README routing marks as read during orientation, and its `rules/rules-global.md` (the global rules normally arrive via the user-level import, but re-reading them keeps re-orientation bulletproof when early context has been compacted).
4. **Resolve the scoped module**:
   - **Argument given**: fuzzy-match it against the `modules/` folder names — exact (case-insensitive), then prefix, then initials/abbreviation (e.g. "aw" → AcmeWidgets), then substring. Exactly one match → use it. Zero or multiple matches → list the modules found and ask which was meant. An argument matching an always-scoped module resolves to no scoped module: re-read that module (step 3) and continue.
   - **No argument**: check each scoped module's declared scope against the current working directory and the work at hand. Every matching module is active (its rules and knowledge apply); when more than one matches, the module matching the work most specifically owns steps 5 and 6, and the report's Modules line names them all. No match → no scoped module.
5. **Module orientation**: if the module owning the flow has an `orient.md` at its root, **follow it now**: it supplies the module's data for this flow (knowledge to always load, a work survey, the session menu, the opening ritual). Otherwise read the module's `README.md` and note its routing, loading rules/knowledge only as the work calls for them.
6. **Close with the orientation report** (defined below): every path ends with it.

## Orientation report

Every orientation, on every path, ends by rendering this structure as the closing message:

```markdown
## Oriented

- **Modules:** <always-scoped modules> + <each matched scoped module> (matched: <one-line reason>), or "+ no scoped module"
- **Work:** <the task as the user stated it>, or "not yet stated"
- **Rule types:** <types from the rule-types registry (`registries/rule-types.md`) this work is expected to trigger>, or "depends on the work"

<tail>
```

The header block is fixed; only the tail varies:

- **Work not stated**: the tail is the session question. A scoped module's `orient.md` supplies the menu and owns its formatting; with no scoped module, ask plainly what this session is for.
- **Work already stated**: the tail confirms the understanding in a sentence or two and flows into the module's opening ritual (e.g. a status read), then waits for confirmation before any work starts.

Questions that interrupt orientation itself (module disambiguation in step 3) come before the report; the report renders once orientation completes.
