---
name: planning-rules
description: Load BEFORE creating, editing, or executing a plan (project plans, implementation plans, phased work). Loads the planning rules from every active module.
---

The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, the baseline folder is the current project root).

1. Identify the active modules under `modules/`: every module whose README declares `Scope: always`, plus any whose declared scope matches the current work. (Skip `_template`.)
2. Read `rules/rules-planning.md` from each active module that has one.
3. Apply them together — on conflict, the more specifically-scoped module's rule wins for its own work.
4. Plans that produce code also load the coding-rules skill; plans that produce docs also load documenting-rules — contexts compose.
