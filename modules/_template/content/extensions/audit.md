# <Module>: /audit extension

<!-- OPTIONAL. Extends the engine's /audit when it targets this module. Its one
     extension point, Checks, runs after the command's generic passes (full-content
     read, reference integrity, content quality). Put here what only a LOCAL audit can
     check (the module's content against the org's live environment) and the module's
     own conventions the engine can't know. Completeness matters more than length: add a
     check whenever an audit catches something by judgment, and update a check in the
     same change as the convention it covers. Delete this file if there's nothing to add. -->

Extends `/audit` when it targets this module. Checks that need <the org's workspace or live systems> are reported as not run on a machine without them, with where they can run.

## Checks (adds)

Example checks (replace with your own):

### Scope accuracy

Do the paths declared in the README's activation scope still exist, and does any active work happen somewhere the scope doesn't cover?

### Knowledge staleness

Diff `knowledge/<living-doc>.md` against the real environment it describes (<e.g. the actual repo list, the actual project folders>); flag entries whose anchors have visibly moved.

### Rules anchors

Rules that name specific files, packages, or branches: spot-check the anchors still exist.

### Scripts and hooks run

Run each script in `scripts/` and each hook in `wiring/hooks/` once without side effects (a dry run, or a sample hook payload) and confirm each does what its guide or header says.

### <A convention of this module's own>

<What must hold across the module's files, and how to check it: e.g. every example in the rules uses the org's real product names.>
