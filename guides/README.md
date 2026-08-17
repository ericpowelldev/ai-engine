# guides/

How-tos for producing common deliverables (plans, summaries, docs), written so the boilerplate never needs restating. A guide is the recipe; the deliverable it produces is the artifact.

## How they run

Guides are user-invoked. Each guide gets a thin command wrapper in `.claude/commands/`, named for the **deliverable** it produces (not the guide's filename), whose body reads the guide and follows it for the current work. Guides also stay reachable without commands — the baseline routing map points here.

## Writing guides

- One deliverable per guide, named `how-to-<produce-the-thing>.md`.
- The produced deliverable must be standalone: it inlines what it needs from other docs rather than linking to them.
- Org-specific guides live in the owning module's `guides/` with module-prefixed command names.

This folder holds only org-agnostic guides. It starts empty — generic versions of module guides get extracted here when a second organization needs them.
