# Coding Rules

<!-- Rules the agent loads before writing, editing, or reviewing code.
     House style: domain-prefixed kebab-case name, brief and imperative, one line of
     why ONLY when it changes how the rule is applied. One concern per rule. -->

Example entries (replace with your own):

- **coding-early-returns** — Prefer guard clauses and early returns over nested conditionals; a function's happy path reads top-to-bottom at one indent level.
- **coding-errors-carry-context** — Every thrown/returned error includes what was being attempted and the offending value — "user 42 not found in org 7", never "not found". Errors are read by someone without a debugger attached.
- **coding-no-dead-flags** — When removing a feature flag, remove both branches and the flag definition in the same change; a flag with one live branch is dead weight that reads as optionality.
