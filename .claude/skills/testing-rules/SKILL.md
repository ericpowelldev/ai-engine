---
name: testing-rules
description: Load BEFORE planning, writing, or running tests of any kind. Loads the testing rules for the current context (generic + active module).
---

The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, the baseline folder is the current project root).

1. Read `rules/rules-testing.md` in the baseline folder.
2. If the work falls within a module's declared scope (each `modules/<Org>/README.md` states its scope), also read that module's `rules/rules-testing.md` if present.
3. Apply both — module rules extend the generic rules; when they conflict, the module rule wins for that module's work.
