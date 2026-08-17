# Coding Rules

- **coding-modular** — Build small single-purpose pieces and assemble them in handler/orchestrator functions whose bodies read as named steps. Split before a function exceeds one concern; name the pieces explicitly in plans so the modular shape is visible upfront.
- **coding-draft-not-refactor** — Unreleased/unmerged code is a draft, not a refactor: no deviation comments, no history framing, no legacy-compatibility shims unless explicitly asked. Comments are for non-obvious constraints only — never for what changed or why the change is correct.
- **coding-no-local-doc-refs** — Code, comments, and commit messages never reference local workspace docs, plan filenames, decision IDs, or home-directory paths. Remove such references proactively when found, and make sure the remaining comment still stands on its own.
- **coding-merge-conflicts** — Resolve merge conflicts with an overview of all conflicts first, then one file at a time: explain both branches' intent, recommend a direction, and wait for approval before editing non-trivial files. Prefer unifying both branches' additions over picking a side. Watch for semantic conflicts git auto-merged silently.
