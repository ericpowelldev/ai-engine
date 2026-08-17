---
description: Orient (or re-orient) the session — baseline plus the relevant module; optionally target a module by name (fuzzy, e.g. "hd" for HopDrive)
---

Orient yourself on the baseline. The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, you are booted inside the baseline folder itself — it is the current project root).

Optional module argument: $ARGUMENTS

1. **Baseline**: read the baseline folder's `CLAUDE.md` (skip if already loaded this session — it normally is, via the user-level import). Read the files in `personal/` to know who the user is.
2. **Resolve the module**:
   - **Argument given**: fuzzy-match it against the `modules/` folder names — exact (case-insensitive), then prefix, then initials/abbreviation (e.g. "hd" → HopDrive), then substring. Exactly one match → use it. Zero or multiple matches → list the modules found and ask which was meant.
   - **No argument**: check each module's declared scope (in its `README.md`) against the current working directory and the work at hand; a match selects that module. No match → no module.
3. **Module orientation**: if the resolved module has an `orient.md` at its root, **follow it now** — it owns the rest of the orientation, including what to ask. Otherwise read the module's `README.md` and note its routing, loading rules/knowledge only as the work calls for them.
4. **If no module orient took over**: ask what this session is for — a **new project**, an **existing project**, an **isolated issue**, or **scratchpad brainstorming** — and confirm before starting any work.

If the user already stated the work in their message, skip the question and confirm your orientation in one short paragraph instead: active module (if any), what you understand the task to be, and which rule types you expect to apply.
