---
description: Orient (or re-orient) the session — always-on modules plus the relevant scoped module; optionally target a module by name (fuzzy — initials or partial names match)
---

Orient yourself. The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, you are booted inside the baseline folder itself — it is the current project root).

Optional module argument: $ARGUMENTS

1. **Baseline mechanics**: read the baseline folder's `CLAUDE.md` (skip if already loaded this session — it normally is, via the user-level import).
2. **Always-scoped modules**: for each module under `modules/` whose README declares `Scope: always` (skip `_template`), read its `README.md`, its identity knowledge (e.g. `knowledge/about.md`), and its `rules/rules-general.md` — the general rules normally arrive via the user-level import, but re-reading them here makes re-orientation bulletproof in long sessions where early context has been compacted.
3. **Resolve the scoped module**:
   - **Argument given**: fuzzy-match it against the `modules/` folder names — exact (case-insensitive), then prefix, then initials/abbreviation (e.g. "aw" → AcmeWidgets), then substring. Exactly one match → use it. Zero or multiple matches → list the modules found and ask which was meant.
   - **No argument**: check each scoped module's declared scope against the current working directory and the work at hand; a match selects that module. No match → no scoped module.
4. **Module orientation**: if the resolved module has an `orient.md` at its root, **follow it now** — it owns the rest of the orientation, including what to ask. Otherwise read the module's `README.md` and note its routing, loading rules/knowledge only as the work calls for them.
5. **If no module orient took over**: ask what this session is for — a **new project**, an **existing project**, an **isolated issue**, or **brainstorming** — and confirm before starting any work.

If the user already stated the work in their message, skip the question and confirm your orientation in one short paragraph instead: active modules, what you understand the task to be, and which rule types you expect to apply.
