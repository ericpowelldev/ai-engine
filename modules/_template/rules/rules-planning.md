# Planning Rules

<!-- Rules the agent loads before creating, editing, or executing a plan. -->

Example entries (replace with your own):

- **planning-small-reviewable-pieces** — Split plans into pieces small enough to review as a single diff; each piece leaves the system working.
- **planning-name-the-risks** — Every plan states what could invalidate it (an unverified assumption, an external dependency) next to the step that depends on it — not in a risks appendix nobody reads.
