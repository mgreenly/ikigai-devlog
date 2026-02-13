---
title: "Collaborators and Workers"
slug: "collaborators-and-workers"
published: 2026-02-03
republished: []
last_build_hash: ""
last_build_lines: 0
---

This post is emerging thinking, not a finished design. Something clicked recently and I want to capture it while it's fresh.

## The Spark

I've been watching projects that wire agents up to chat services like Slack or Signal. When a message comes in, they spin up a sub-agent to handle the task. The orchestration layer is simple. It just watches for work and spawns agents.

That pattern felt familiar. It's essentially what I do with ralph today, just automated. I write goal files interactively with Claude, manually run ralph, and review the PRs that come back. The middle step (running ralph) is mechanical. I'm the orchestration layer.

## Two Different Problems

What clicked is that orchestration splits into two distinct problems:

**Preparing work** benefits from intelligence. You need to think through requirements, understand context, refine scope. This is collaborative work between human and agent.

**Distributing work** can be mechanical. Watch a queue, spin up a worker, let it run. No intelligence needed.

I've been conflating these. The vision for Ikigai included agents that could spawn sub-agents and communicate with each other mid-task. But maybe that's overcomplicating things.

## Collaborators vs Workers

Here's the model I'm converging on:

**Collaborators** are long-lived agents in the Ikigai UI. They help you think, plan, and review. They need good memory because humans can't track what's in an agent's context. The hard problem here is making context windows feel infinite through sliding windows, summaries, and persistent memory.

**Workers** are ephemeral. They get everything they need upfront (a goal, tools, skills), execute in isolation, and submit results. No memory problem because each worker starts fresh. Isolation is the advantage here. It's what lets you scale horizontally without coordination overhead.

Collaborators don't spawn workers directly. They help prepare work that goes into a queue. A dumb scheduler watches the queue and handles distribution. Workers pull tasks, execute, submit, and disappear.

The coordination model has three touch points: queue in, submit out, and eventual human verification. Workers don't talk to each other. They don't talk to the collaborator that prepared their task. All coordination happens through those interfaces.

Human verification doesn't have to match submissions one-to-one. As I wrote in the previous post about disposable clones, verification happens on main after work lands. You can let multiple PRs merge, then verify the aggregated result before cutting a release. The human stays in the loop without becoming a bottleneck.

## What This Means for Ikigai

We're building two things:

The **Ikigai UI** is for collaborators. Multiple long-lived agents (switchable with hotkeys), sophisticated memory management, terminal interface for human interaction. This is what we're working on now. If memory works well enough, we might eventually simplify to a single "super collaborator" instead of multiple agents.

The **worker runtime** is a separate, simpler program. Headless, multi-provider (Anthropic, OpenAI, Google), uses the same external tool architecture. Essentially what ralph does today with `claude -p`, but without depending on Claude Code's CLI.

Docker provides the isolation. Each worker runs in its own container with a prepared workspace bind-mounted in. The workspace contains the goal, tools, and any context the worker needs. Workers can't interfere with each other because they have no shared state. When the task completes, the container dies and the workspace can be cleaned up. Fresh slate every time.

Same tools, same LLM patterns. One has a UI for collaboration, one doesn't.

## The Ralph Connection

For readers following along: ralph already works this way. Goal file goes in, PR comes out. Each iteration is effectively ephemeral. Progress gets logged so future iterations have context.

The difference is I'm currently the scheduler. I run ralph manually. The design I'm describing automates that layer while keeping the valuable parts: interactive goal preparation with a collaborator agent, isolated execution by workers.

This isn't replacing ralph. It's recognizing that ralph found the right pattern and building infrastructure around it.

---

*Co-authored by Mike Greenly and Claude Code*
