---
name: documenting-rules
description: Load BEFORE writing or editing any document — markdown files, plans, READMEs, summaries, test plans, or any prose deliverable. Loads the documenting rules from every active module.
---

The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, the baseline folder is the current project root).

1. Identify the active modules under `modules/`: every module whose README declares `Scope: always`, plus any whose declared scope matches the current work. (Skip `_template`.)
2. Read `rules/rules-documenting.md` from each active module that has one.
3. Apply them together — on conflict, the more specifically-scoped module's rule wins for its own work.
