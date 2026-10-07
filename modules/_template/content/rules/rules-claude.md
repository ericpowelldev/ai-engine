# Claude Rules

<!-- Agent rules: always-on rules specific to one brand of agent, here Claude. Only
     meaningful in a global (Scope: always) module: the Claude adapter (/setup) wires
     this file into the user-level always-on layer, and the registry lists the type as
     "Reserved:". Another agent gets its own file (rules-grok.md, rules-chatgpt.md, ...).
     Rule names take the agent's prefix. Keep every rule to its statement: every line
     costs every session. -->

Example entries (replace with your own):

## claude-<concept>

<One always-on rule specific to Claude: for example, which file Claude uses as its instruction file, or how it picks a model before dispatching another agent.>
