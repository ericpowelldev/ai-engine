---
description: Look up a rule by exact name, rule type, or keyword and show its current wording from the module rule files
---

Look up rules across the modules. The baseline folder is `{{AI_DIR}}` (if that placeholder is literal, you are booted inside the baseline folder itself — it is the current project root).

Lookup argument: $ARGUMENTS

1. **Inventory**: list every `rules/rules-<type>.md` under `modules/` (skip `_template`), and note which modules are active (always-scoped, plus any whose scope matches the current work).
2. **Resolve the argument** (first match wins):
   - **Exact rule name** (domain-prefixed, e.g. `global-git-safety`): print that rule's entry, with the owning module and file.
   - **Rule type** (a registered type from `registries/rule-types.md`, e.g. `coding`): print every rule of that type, grouped by module.
   - **Keyword**: search rule names and bodies across all rule files; print each matching rule, grouped by module.
   - **No argument**: print the inventory (registered types, and per module its rule files with a rule count per file).
3. **Report format**: quote each rule's wording verbatim (never paraphrase), cite its module and file, and mark rules from inactive modules as not currently in force (shown for reference). If two modules carry near-identical rules, point out the overlap.
