# <Module>: /setup extension

<!-- OPTIONAL. Extends the engine's /setup when this module is in scope. Its one
     extension point, Steps, holds org-specific environment prep: credentials
     pointers, local services, extra tooling. Delete this file if the module needs no
     setup beyond wiring. -->

## Steps (adds)

Example steps (replace with your own):

1. Verify <the org's CLI / local stack> is installed; if not, point the user at <install doc>.
2. Confirm the environment file at `<path>` exists with the keys `<A>`, `<B>` (never read or print their values).
