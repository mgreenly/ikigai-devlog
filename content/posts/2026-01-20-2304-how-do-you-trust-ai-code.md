---
title: "How Do You Trust AI Code?"
slug: "how-do-you-trust-ai-code"
published: 2026-01-20
republished: []
last_build_hash: ""
last_build_lines: 0
---

People ask how I can trust code that an AI writes.

The same way I trust code that humans write. Which is to say: I don't. The code has to earn trust.

Every piece of code, regardless of author, runs the same gauntlet:

**Review.** Someone else looks at it from a different angle. Human reviewer, AI reviewer, doesn't matter. Fresh eyes catch what the author missed.

**Testing.** Unit tests, integration tests, functional tests. We're not testing the author's competence, we're testing the code's behavior.

**Analysis.** Static analysis, sanitizers, coverage checks. Automated tools don't care who wrote the code. They just find problems.

**Deployment.** Does it work in staging? Does it work in production? Does it keep working over time?

There's no checkbox that declares code trustworthy. Trust accumulates through evidence. This is true whether the author is human or AI.

The interesting part is what changes when you stop treating AI code as suspicious and start treating it the same as any other code. You stop reviewing it differently. You stop looking for "AI mistakes" versus "human mistakes." You just run the gauntlet and see what survives.

This is the whole point of building quality harnesses. You don't trust the code. You trust the process that validates it.

*Co-authored by Mike Greenly and Claude Code*
