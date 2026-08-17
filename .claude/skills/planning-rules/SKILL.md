---
name: planning-rules
description: Load BEFORE creating, editing, or executing a plan (project plans, implementation plans, phased work). Loads the planning rules for the current context (generic + active module).
---

The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, the baseline folder is the current project root).

1. Read `rules/rules-planning.md` in the baseline folder.
2. If the work falls within a module's declared scope (each `modules/<Org>/README.md` states its scope), also read that module's `rules/rules-planning.md` if present.
3. Apply both — module rules extend the generic rules; when they conflict, the module rule wins for that module's work.
4. Plans that produce code also load the coding-rules skill; plans that produce docs also load documenting-rules — contexts compose.
