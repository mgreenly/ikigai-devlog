---
title: "Thinking in Silos"
slug: "thinking-in-silos"
published: 2026-01-29
republished: []
last_build_hash: ""
last_build_lines: 0
---

When you're running multiple agents in parallel, the way you plan work changes. You stop thinking about what to do next and start thinking about what can be isolated.

I'm on the Anthropic Max 20x plan, and my goal each week is to slightly exceed it, dipping into the bulk token pricing. The way to do that efficiently isn't one massive multi-day run. It's several moderate features progressing simultaneously. This only works if you can carve your codebase into independent silos that agents can work in without stepping on each other.

## Natural Isolation Points

Some isolation is structural. Ikigai has three independent AI provider modules (Anthropic, OpenAI, Google Gemini) that share a common interface through a vtable. Improvements to the Anthropic streaming code don't touch the Google request serialization. An agent can work in `src/providers/anthropic/` while another works in `src/providers/google/` with no conflicts.

External tools are similarly isolated. Each tool is a standalone program in its own directory under `tools/`. They communicate with the main application through pipes and JSON. An agent adding a new tool has zero interaction with agents working on the REPL or the database layer.

Then there's the build system. I spent time early in this release cycle stabilizing the interface between the check-* scripts and ralph. Each script returns a simple JSON structure: `{"ok": true}` or `{"ok": false, "items": [...]}`. As long as I maintain that contract, I can restructure the Makefile or rewrite the harness internals without breaking the agents that depend on them. The interface is the boundary.

## Planning for Parallelism

The mental model shifts when you think this way. Looking at the ikigai roadmap, I'm now evaluating features by their isolation potential as much as their importance.

**Internal tool exposure:** Fork, kill, and mail commands already exist as user commands in the codebase. The next step is exposing them through a unified `/slash` interface so the LLM can use them autonomously. This is mostly new code in a single module that merges with the external tool list when sent to models. Very isolated.

**External API:** Ikigai will eventually have a unix socket or HTTP interface that external scripts can connect to. While we're building it, it's completely separate from everything else. Multiple agents might not be able to work on different aspects of the API simultaneously, but at least one can always be making progress without blocking other work.

**Dead code cleanup:** There's accumulated dead code that needs removal. This is actually harder than it sounds. It's like proving a negative. You have to verify nothing is using the code you're about to delete, and in a codebase with vtables and late binding, static analysis won't save you. But it's easy to run cleanup agents in isolated corners of the codebase while other agents build features elsewhere.

**Documentation and platform support:** Both are naturally parallel. Documentation doesn't touch implementation. Adding Fedora, Arch, or macOS support means working in platform-specific modules that don't affect the core application.

## The Acceleration Effect

This approach compounds. As the codebase grows, more natural silos emerge. New tools are external by design. Provider modules are independent by architecture. The harness interface stays stable while implementation evolves.

We're not quite to the point where agents manage other agents. But we're getting closer to a workflow where you maintain a board of isolated work items and just keep feeding them to agents as they complete. The bottleneck shifts from "how fast can I code" to "how well can I decompose work."

The future is very parallel.

*Co-authored by Mike Greenly and Claude Code*
