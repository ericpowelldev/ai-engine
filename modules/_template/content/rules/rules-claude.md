# Claude Rules

<!-- Agent rules: always-on rules specific to one brand of agent, here Claude. Only
     meaningful in a global (Scope: always) module: the Claude adapter (/setup) wires
     this file into the user-level always-on layer, and the registry lists the type as
     "Reserved:". Another agent gets its own file (rules-grok.md, rules-chatgpt.md, ...).
     Rule names take the agent's prefix. Optional categories: name them in an intro line
     like the one below and put each rule's category after the prefix
     (`claude-<category>-<concept>`). Keep every rule to its statement: every line costs
     every session. -->

Model rules govern which model the agent runs on; subagent rules govern when and how it dispatches other agents.

Example entries (replace with your own):

## claude-model-explicit

Set every subagent's model explicitly when dispatching it, chosen for the task; never rely on a default.

## claude-subagent-briefing

Brief a subagent with everything it needs to finish without asking: its task, the paths and facts it needs, and what to return.
