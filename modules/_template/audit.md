# <Module> Audit Checks

<!-- OPTIONAL. Module-specific checks run by /audit when targeting this module, after
     the command's generic passes (full-content read, reference integrity, content
     quality). Put here what only a LOCAL audit can check: the module's content
     against the org's live environment. Delete this file if there's nothing local
     to verify. -->

Example checks (replace with your own):

## Scope accuracy

Do the paths declared in the README's activation scope still exist, and does any active work happen somewhere the scope doesn't cover?

## Knowledge staleness

Diff `knowledge/<living-doc>.md` against the real environment it describes (<e.g. the actual repo list, the actual project folders>); flag entries whose anchors have visibly moved.

## Rules anchors

Rules that name specific files, packages, or branches: spot-check the anchors still exist.
