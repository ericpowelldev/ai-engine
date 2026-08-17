# Testing Rules

<!-- Rules the agent loads before planning, writing, or running tests. -->

Example entries (replace with your own):

- **testing-behavior-not-implementation** — Tests assert observable behavior (inputs → outputs, emitted events), never internal call sequences; a refactor that preserves behavior must not break tests.
- **testing-one-assertion-theme** — Each test verifies one behavior and is named for it (`rejects expired tokens`); a failing test's name alone should say what broke.
