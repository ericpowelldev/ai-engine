---
name: designing-rules
description: Load BEFORE any UI, UX, mockup, styling, or visual design work — components, layouts, colors, typography, themes. Loads the designing rules from every active module.
---

The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, the baseline folder is the current project root).

1. Identify the active modules under `modules/`: every module whose README declares `Scope: always`, plus any whose declared scope matches the current work. (Skip `_template`.)
2. Read `rules/rules-designing.md` from each active module that has one.
3. Apply them together — on conflict, the more specifically-scoped module's rule wins for its own work.
