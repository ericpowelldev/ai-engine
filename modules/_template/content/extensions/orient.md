# <Module>: /orient extension

<!-- OPTIONAL. Extends the engine's /orient once this module is resolved. The command
     owns the procedure (the orientation report, the closing session question); each
     `##` section below names one of its extension points and says whether it ADDS to
     or REPLACES the base behavior. Every active module's additions apply; when two
     modules replace the same point, the more specifically-scoped module wins. Delete
     a section to leave that point alone, or this file to fall back to the generic
     behavior (follow the README's layout). -->

## Always-load knowledge (adds)

<The knowledge docs a session always needs, e.g. the workspace map>. Keep the rest as lookups.

## Work survey (adds)

<e.g. list the org's work folders: names only, don't read into them>.

## Session menu (adds)

<The real options by name, e.g. existing effort X / a new effort / a quick question>.

## Starting work (adds)

<A pointer to the doc that owns the steps to follow once the next prompt names the work>.
