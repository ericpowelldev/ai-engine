# Global Rules

<!-- Always-on behavioral rules — how the agent works with you, regardless of task.
     Only meaningful in a global (Scope: always) module: /setup wires this file into
     the user-level always-on layer. Keep it SHORT — every line costs every session. -->

Example entries (replace with your own):

- **global-confirm-destructive** — Confirm before any destructive or hard-to-reverse action (deletes, force-pushes, overwrites of uncommitted work). A directive to do the task is not a directive to destroy things in its path.
- **global-no-speculative-work** — Do only what was asked. Adjacent improvements are proposed at the end, not silently included.
