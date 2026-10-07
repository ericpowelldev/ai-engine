# Coding Rules

<!-- Rules the agent loads before writing, editing, or reviewing code.
     House style: one named section per rule. The `##` heading is the rule's
     domain-prefixed kebab-case name; the first paragraph is a brief, imperative
     statement of the rule. Detail below it (examples, tables, exceptions) is
     optional: add only what the rule needs to be followed correctly. One concern
     per rule. -->

Example entries (replace with your own):

## coding-early-returns

Prefer guard clauses and early returns over nested conditionals; a function's happy path reads top-to-bottom at one indent level.

## coding-errors-carry-context

Every thrown or returned error includes what was being attempted and the offending value. Errors are read by someone without a debugger attached.

```typescript
// Good
throw new Error(`user ${userId} not found in org ${orgId}`);

// Bad
throw new Error("not found");
```

## coding-no-dead-flags

When removing a feature flag, remove both branches and the flag definition in the same change; a flag with one live branch is dead weight that reads as optionality.
